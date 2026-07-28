import 'package:barbershop_app/providers/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../providers/app_provider.dart';
import '../utils/app_theme.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(myBookingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Bookings",
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),

      body: bookings.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (e, _) => Center(
          child: Text(e.toString()),
        ),

        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Text(
                "No Bookings Yet",
                style: GoogleFonts.raleway(
                  color: AppColors.textMuted,
                  fontSize: 18,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final booking = list[index];

              return _BookingCard(booking: booking)
                  .animate(delay: (index * 80).ms)
                  .fadeIn()
                  .slideY(begin: .15);
            },
          );
        },
      ),
    );
  }
}


class _BookingCard extends ConsumerWidget  {
  final Map<String, dynamic> booking;

  const _BookingCard({
    required this.booking,
  });

  @override
 Widget build(BuildContext context, WidgetRef ref) {
    final barber =
        booking['barbers'] as Map<String, dynamic>? ?? {};

    final service =
        booking['services'] as Map<String, dynamic>? ?? {};

    final status = booking['status'] ?? 'pending';

    Color statusColor;

switch (status) {
  case 'pending':
    statusColor = Colors.orange;
    break;

  case 'confirmed':
    statusColor = Colors.green;
    break;

  case 'completed':
    statusColor = Colors.blue;
    break;

  case 'cancelled':
    statusColor = Colors.red;
    break;

  default:
    statusColor = Colors.grey;
}

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage(barber['image_url'] ?? ''),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      barber['name'] ?? '',
                      style: GoogleFonts.raleway(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      service['name'] ?? '',
                      style: GoogleFonts.raleway(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.15),
                  borderRadius:
                      BorderRadius.circular(30),
                ),
                child: Text(
  status[0].toUpperCase() + status.substring(1),
  style: GoogleFonts.raleway(
    color: statusColor,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  ),
),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              const Icon(Icons.calendar_today_rounded,
                  size: 18),

              const SizedBox(width: 8),

              Text(
                DateFormat('dd MMM yyyy').format(
                  DateTime.parse(
                    booking['booking_date'],
                  ),
                ),
              ),

              const Spacer(),

              const Icon(Icons.access_time_rounded,
                  size: 18),

              const SizedBox(width: 8),

              Text(booking['time_slot']),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Text(
                "Price",
                style: GoogleFonts.raleway(),
              ),

              const Spacer(),

              Text(
                "£${service['price']}",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

if (status != 'completed' && status != 'cancelled')
  SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
     onPressed: () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Cancel Booking"),
      content: const Text(
        "Are you sure you want to cancel this booking?",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("No"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Yes"),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  await ref
      .read(bookingServiceProvider)
      .cancelBooking(booking['id']);

  ref.invalidate(myBookingsProvider);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Booking Cancelled"),
    ),
  );
},
      icon: const Icon(Icons.close),
      label: const Text("Cancel Booking"),
    ),
  ),
        ],
      ),
    );
  }
}