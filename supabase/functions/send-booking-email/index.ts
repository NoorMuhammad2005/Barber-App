// supabase/functions/send-booking-email/index.ts
// Deploy with: supabase functions deploy send-booking-email

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY") ?? "";
const FROM_EMAIL = "bookings@noirbarber.co.uk";
const FROM_NAME = "Noir Barber";

interface BookingPayload {
  to: string;
  clientName: string;
  serviceName: string;
  barberName: string;
  date: string;
  timeSlot: string;
  price: number;
  bookingId: string;
  language?: "en" | "ar";
}

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
      },
    });
  }

  try {
    const payload: BookingPayload = await req.json();
    const isAr = payload.language === "ar";

    const subject = isAr
      ? `✅ تم تأكيد حجزك — نوار باربر`
      : `✅ Booking Confirmed — Noir Barber`;

    const html = isAr
      ? buildArabicEmail(payload)
      : buildEnglishEmail(payload);

    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${RESEND_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        from: `${FROM_NAME} <${FROM_EMAIL}>`,
        to: [payload.to],
        subject,
        html,
      }),
    });

    const data = await res.json();

    return new Response(JSON.stringify({ success: true, data }), {
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
    });
  } catch (err) {
    return new Response(
      JSON.stringify({ success: false, error: String(err) }),
      {
        status: 500,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
      }
    );
  }
});

function buildEnglishEmail(p: BookingPayload): string {
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Booking Confirmed — Noir Barber</title>
</head>
<body style="background:#0A0A0A;font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;margin:0;padding:20px;">
  <div style="max-width:520px;margin:0 auto;background:#141414;border-radius:20px;border:1px solid #2a2a2a;overflow:hidden;">

    <!-- Header -->
    <div style="background:linear-gradient(135deg,#1A1500,#0d0b00);padding:32px;text-align:center;border-bottom:1px solid #2a2a2a;">
      <div style="font-size:40px;margin-bottom:8px;">✂️</div>
      <div style="color:#D4AF37;font-size:24px;font-weight:700;letter-spacing:4px;">NOIR BARBER</div>
      <div style="color:#666;font-size:12px;letter-spacing:2px;margin-top:4px;">WHERE ART MEETS LUXURY</div>
    </div>

    <!-- Success badge -->
    <div style="text-align:center;padding:24px 24px 0;">
      <div style="display:inline-block;background:rgba(46,204,113,0.12);border:1px solid rgba(46,204,113,0.3);border-radius:50px;padding:8px 20px;">
        <span style="color:#2ECC71;font-size:14px;font-weight:700;">✅ Booking Confirmed</span>
      </div>
      <h1 style="color:#F5F5F5;font-size:22px;margin:12px 0 4px;">Hi ${p.clientName}!</h1>
      <p style="color:#888;font-size:14px;margin:0;">Your appointment is all set. See you soon!</p>
    </div>

    <!-- Booking details -->
    <div style="margin:24px;background:#1E1E1E;border-radius:16px;border:1px solid #2a2a2a;overflow:hidden;">
      ${detailRow("✂️", "Service", p.serviceName)}
      ${detailRow("👨", "Barber", p.barberName)}
      ${detailRow("📅", "Date", p.date)}
      ${detailRow("🕐", "Time", p.timeSlot)}
      ${detailRow("💷", "Amount Paid", `£${p.price.toFixed(2)}`, true)}
    </div>

    <!-- Booking reference -->
    <div style="margin:0 24px 24px;text-align:center;">
      <p style="color:#666;font-size:11px;letter-spacing:1px;margin-bottom:4px;">BOOKING REFERENCE</p>
      <code style="color:#D4AF37;font-size:14px;font-weight:700;letter-spacing:2px;">${p.bookingId.toUpperCase().slice(0, 12)}</code>
    </div>

    <!-- CTA -->
    <div style="margin:0 24px 24px;">
      <a href="https://noirbarber.co.uk/booking/${p.bookingId}"
         style="display:block;background:linear-gradient(135deg,#D4AF37,#AA8C2C);color:#0A0A0A;text-align:center;padding:14px;border-radius:12px;font-weight:700;font-size:14px;letter-spacing:1px;text-decoration:none;">
        VIEW BOOKING
      </a>
    </div>

    <!-- Footer -->
    <div style="padding:20px 24px;border-top:1px solid #1e1e1e;text-align:center;">
      <p style="color:#444;font-size:12px;margin:0 0 8px;">42 Mayfair Street, London W1K 4HX</p>
      <p style="color:#444;font-size:12px;margin:0;">
        <a href="tel:+442079460958" style="color:#D4AF37;text-decoration:none;">+44 20 7946 0958</a>
        &nbsp;·&nbsp;
        <a href="https://wa.me/442079460958" style="color:#25D366;text-decoration:none;">WhatsApp</a>
      </p>
    </div>
  </div>
</body>
</html>`;
}

function buildArabicEmail(p: BookingPayload): string {
  return `
<!DOCTYPE html>
<html dir="rtl">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>تأكيد الحجز — نوار باربر</title>
</head>
<body style="background:#0A0A0A;font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;margin:0;padding:20px;direction:rtl;">
  <div style="max-width:520px;margin:0 auto;background:#141414;border-radius:20px;border:1px solid #2a2a2a;overflow:hidden;">

    <div style="background:linear-gradient(135deg,#1A1500,#0d0b00);padding:32px;text-align:center;border-bottom:1px solid #2a2a2a;">
      <div style="font-size:40px;margin-bottom:8px;">✂️</div>
      <div style="color:#D4AF37;font-size:24px;font-weight:700;letter-spacing:2px;">نوار باربر</div>
      <div style="color:#666;font-size:12px;margin-top:4px;">حيث الفن يلتقي بالفخامة</div>
    </div>

    <div style="text-align:center;padding:24px 24px 0;">
      <div style="display:inline-block;background:rgba(46,204,113,0.12);border:1px solid rgba(46,204,113,0.3);border-radius:50px;padding:8px 20px;">
        <span style="color:#2ECC71;font-size:14px;font-weight:700;">✅ تم تأكيد الحجز</span>
      </div>
      <h1 style="color:#F5F5F5;font-size:22px;margin:12px 0 4px;">مرحباً ${p.clientName}!</h1>
      <p style="color:#888;font-size:14px;margin:0;">تم تأكيد موعدك. نتطلع لرؤيتك!</p>
    </div>

    <div style="margin:24px;background:#1E1E1E;border-radius:16px;border:1px solid #2a2a2a;overflow:hidden;">
      ${detailRow("✂️", "الخدمة", p.serviceName)}
      ${detailRow("👨", "الحلاق", p.barberName)}
      ${detailRow("📅", "التاريخ", p.date)}
      ${detailRow("🕐", "الوقت", p.timeSlot)}
      ${detailRow("💷", "المبلغ المدفوع", `£${p.price.toFixed(2)}`, true)}
    </div>

    <div style="margin:0 24px 24px;text-align:center;">
      <p style="color:#666;font-size:11px;letter-spacing:1px;margin-bottom:4px;">رقم الحجز</p>
      <code style="color:#D4AF37;font-size:14px;font-weight:700;">${p.bookingId.toUpperCase().slice(0, 12)}</code>
    </div>

    <div style="margin:0 24px 24px;">
      <a href="https://noirbarber.co.uk/booking/${p.bookingId}"
         style="display:block;background:linear-gradient(135deg,#D4AF37,#AA8C2C);color:#0A0A0A;text-align:center;padding:14px;border-radius:12px;font-weight:700;font-size:14px;text-decoration:none;">
        عرض تفاصيل الحجز
      </a>
    </div>

    <div style="padding:20px 24px;border-top:1px solid #1e1e1e;text-align:center;">
      <p style="color:#444;font-size:12px;margin:0 0 8px;">42 شارع ماي فير، لندن W1K 4HX</p>
      <p style="color:#444;font-size:12px;margin:0;">
        <a href="https://wa.me/442079460958" style="color:#25D366;text-decoration:none;">واتساب</a>
        &nbsp;·&nbsp;
        <a href="tel:+442079460958" style="color:#D4AF37;text-decoration:none;">+44 20 7946 0958</a>
      </p>
    </div>
  </div>
</body>
</html>`;
}

function detailRow(emoji: string, label: string, value: string, isGold = false): string {
  return `
  <div style="display:flex;align-items:center;justify-content:space-between;padding:14px 16px;border-bottom:1px solid #2a2a2a;">
    <div style="display:flex;align-items:center;gap:10px;">
      <span style="font-size:18px;">${emoji}</span>
      <span style="color:#888;font-size:13px;">${label}</span>
    </div>
    <span style="color:${isGold ? "#D4AF37" : "#F5F5F5"};font-size:14px;font-weight:700;">${value}</span>
  </div>`;
}
