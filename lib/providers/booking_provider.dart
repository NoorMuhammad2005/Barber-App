import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/booking_service.dart';

final bookingServiceProvider = Provider<BookingService>((ref) {
  return BookingService();
});

final bookedSlotsProvider =
    FutureProvider.family<List<String>, ({String barberId, DateTime date})>(
        (ref, params) async {
  return ref.read(bookingServiceProvider).getBookedSlots(
        barberId: params.barberId,
        date: params.date,
      );
});

final allBookingsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final client = Supabase.instance.client;

  final data = await client.from('bookings').select('''
      *,
      services(name,price),
      barbers(name,image_url)
    ''').order('booking_date').order('time_slot');

  return List<Map<String, dynamic>>.from(data);
});

final bookingUpdateProvider = Provider((ref) {
  return ref.read(bookingServiceProvider);
});

// final dashboardProvider = FutureProvider<Map<String, dynamic>>((ref) async {
//   final client = Supabase.instance.client;

//   final bookings = List<Map<String, dynamic>>.from(
//     await client.from('bookings').select(),
//   );

//   List<double> weeklyRevenue = List.filled(7, 0);

//   final now = DateTime.now();

//   for (final b in bookings) {
//     if ((b['status'] ?? '') != 'completed') continue;

//     if (b['booking_date'] == null) continue;

//     final date = DateTime.tryParse(
//       b['booking_date'].toString(),
//     );

//     if (date == null) continue;

//     final diff = now.difference(date).inDays;

//     if (diff >= 0 && diff < 7) {
//       final index = 6 - diff;

//       weeklyRevenue[index] += ((b['total_price'] ?? 0) as num).toDouble();
//     }
//   }
//   final services = List<Map<String, dynamic>>.from(
//     await client.from('services').select(),
//   );

//   final barbers = List<Map<String, dynamic>>.from(
//     await client.from('barbers').select(),
//   );

//   double revenue = 0;
//   int todayBookings = 0;

//   final today = DateTime.now();
//   int pending = 0;
//   int completed = 0;

//   for (final b in bookings) {
//     if (b['booking_date'] == null) continue;

//     final bookingDate = DateTime.tryParse(
//       b['booking_date'].toString(),
//     );

//     if (bookingDate == null) continue;

//     if (bookingDate.year == today.year &&
//         bookingDate.month == today.month &&
//         bookingDate.day == today.day) {
//       todayBookings++;
//     }
//     if (b['status'] == 'completed') {
//       completed++;
//       revenue += (b['total_price'] ?? 0).toDouble();
//     }

//     if (b['status'] == 'pending') {
//       pending++;
//     }
//   }

//   return {
//     "revenue": revenue,
//     "bookings": bookings.length,
//     "pending": pending,
//     "completed": completed,
//     "services": services.length,
//     "barbers": barbers.length,
//     "weeklyRevenue": weeklyRevenue,
//     "todayBookings": todayBookings,
//     "pendingBookings": pending,
//   };
// });


final dashboardProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final client = Supabase.instance.client;

  final bookings = await client.from('bookings').select();

  List<double> weeklyRevenue = List.filled(7, 0);

for (final b in bookings) {
  if (b['status'] != 'completed') continue;

  final date = DateTime.tryParse(
    b['booking_date'].toString(),
  );

  if (date == null) continue;

  final diff = DateTime.now().difference(date).inDays;

  if (diff >= 0 && diff < 7) {
    weeklyRevenue[6 - diff] +=
        ((b['total_price'] ?? 0) as num).toDouble();
  }
}

  final today = DateTime.now().toIso8601String().split('T')[0];

  int todayBookings = 0;

  for (final b in bookings) {
    if (b['booking_date'] == today) {
      todayBookings++;
    }
  }

  final barbers = await client.from('barbers').select();

  final services = await client.from('services').select();

  int pending = 0;
  int confirmed = 0;
  int completed = 0;
  int cancelled = 0;

  double revenue = 0;

  for (final b in bookings) {
    switch (b['status']) {
      case 'pending':
        pending++;
        break;

      case 'confirmed':
        confirmed++;
        break;

      case 'completed':
        completed++;
        revenue += (b['total_price'] ?? 0).toDouble();
        break;

      case 'cancelled':
        cancelled++;
        break;
    }
  }

  return {
    "totalBookings": bookings.length,
    "pending": pending,
    "confirmed": confirmed,
    "completed": completed,
    "cancelled": cancelled,
    "revenue": revenue,
    "barbers": barbers.length,
    "services": services.length,
    "todayBookings": todayBookings,
    "weeklyRevenue": weeklyRevenue,
  };
});
