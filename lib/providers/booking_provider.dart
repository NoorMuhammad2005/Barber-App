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



final dashboardProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final client = Supabase.instance.client;

  final bookings = await client
    .from('bookings')
    .select('''
      *,
      services(name),
      barbers(name)
    ''')
    .order('booking_date', ascending: false)
    .order('time_slot', ascending: false);

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

  final topServices = await client
    .from('bookings')
    .select('services(name)')
    .eq('status', 'completed');

  int pending = 0;
  int confirmed = 0;
  int completed = 0;
  int cancelled = 0;

 double revenue = 0;

Map<String, int> serviceCount = {};

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

  for (final item in topServices) {
  final service = item['services'];

  if (service == null) continue;

  final name = service['name'];

  serviceCount[name] = (serviceCount[name] ?? 0) + 1;
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
    "topServices": serviceCount,
    "recentBookings": bookings.take(5).toList(),
  };
});
