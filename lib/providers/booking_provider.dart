import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/booking_service.dart';

final bookingServiceProvider = Provider<BookingService>((ref) {
  return BookingService();
});

final bookedSlotsProvider = FutureProvider.family<List<String>,
    ({String barberId, DateTime date})>((ref, params) async {
  return ref.read(bookingServiceProvider).getBookedSlots(
        barberId: params.barberId,
        date: params.date,
      );
});

final allBookingsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final client = Supabase.instance.client;

  final data = await client
      .from('bookings')
      .select()
      .order('booking_date')
      .order('time_slot');

  return List<Map<String, dynamic>>.from(data);
});

final bookingUpdateProvider = Provider((ref) {
  return ref.read(bookingServiceProvider);
});