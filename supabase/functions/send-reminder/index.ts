// supabase/functions/send-reminder/index.ts
// Deploy with: supabase functions deploy send-reminder
// Triggered by pg_cron or Supabase scheduler 1 hour before each appointment

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const TWILIO_ACCOUNT_SID = Deno.env.get("TWILIO_ACCOUNT_SID") ?? "";
const TWILIO_AUTH_TOKEN = Deno.env.get("TWILIO_AUTH_TOKEN") ?? "";
const TWILIO_FROM = Deno.env.get("TWILIO_FROM") ?? ""; // WhatsApp-enabled number
const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SUPABASE_SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

serve(async (_req: Request) => {
  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

  // Find bookings starting in ~60 min that haven't been reminded yet
  const now = new Date();
  const inOneHour = new Date(now.getTime() + 60 * 60 * 1000);
  const inOneHourPlus5 = new Date(now.getTime() + 65 * 60 * 1000);

  const { data: bookings, error } = await supabase
    .from("bookings")
    .select(`
      id,
      time_slot,
      date,
      reminder_sent,
      services ( name, name_ar ),
      barbers ( name, name_ar ),
      users ( phone, name )
    `)
    .eq("status", "confirmed")
    .eq("reminder_sent", false)
    .gte("date", now.toISOString().split("T")[0])
    .lte("date", inOneHourPlus5.toISOString().split("T")[0]);

  if (error) {
    console.error("DB error:", error);
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }

  const results = [];

  for (const booking of bookings ?? []) {
    const phone = booking.users?.phone;
    if (!phone) continue;

    const service = booking.services?.name ?? "your appointment";
    const barber = booking.barbers?.name ?? "";
    const name = booking.users?.name ?? "there";
    const time = booking.time_slot;

    const message =
      `✂️ *Noir Barber Reminder*\n\n` +
      `Hi ${name}! Your ${service} with ${barber} is in *1 hour* at *${time}*.\n\n` +
      `📍 42 Mayfair Street, London W1K 4HX\n\n` +
      `Need to reschedule? Call us: +44 20 7946 0958`;

    // Send via Twilio WhatsApp
    const twilioRes = await fetch(
      `https://api.twilio.com/2010-04-01/Accounts/${TWILIO_ACCOUNT_SID}/Messages.json`,
      {
        method: "POST",
        headers: {
          Authorization: `Basic ${btoa(`${TWILIO_ACCOUNT_SID}:${TWILIO_AUTH_TOKEN}`)}`,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: new URLSearchParams({
          From: `whatsapp:${TWILIO_FROM}`,
          To: `whatsapp:${phone}`,
          Body: message,
        }),
      }
    );

    if (twilioRes.ok) {
      // Mark as reminded
      await supabase
        .from("bookings")
        .update({ reminder_sent: true })
        .eq("id", booking.id);

      results.push({ bookingId: booking.id, sent: true });
    } else {
      const err = await twilioRes.text();
      console.error(`Failed for booking ${booking.id}:`, err);
      results.push({ bookingId: booking.id, sent: false, error: err });
    }
  }

  return new Response(
    JSON.stringify({ processed: results.length, results }),
    {
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
    }
  );
});
