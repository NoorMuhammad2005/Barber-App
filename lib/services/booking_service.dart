import 'package:supabase_flutter/supabase_flutter.dart';

class BookingService {
  final _client = Supabase.instance.client;

  Future<void> createBooking({
    required String barberId,
    required String serviceId,
    required DateTime date,
    required String timeSlot,
  }) async {
    final user = _client.auth.currentUser!;
    if (user == null) {
   throw Exception("Please login first.");
  }

    final existing = await _client
    .from('bookings')
    .select()
    .eq('barber_id', barberId)
    .eq('booking_date', date.toIso8601String().split('T')[0])
    .eq('time_slot', timeSlot);

if (existing.isNotEmpty) {
  throw Exception('This slot is already booked.');
}

    await _client.from('bookings').insert({
      'user_id': user.id,
      'barber_id': barberId,
      'service_id': serviceId,
      'booking_date': date.toIso8601String().split('T')[0],
      'time_slot': timeSlot,
      'status': 'confirmed',
    });
  }
  Future<List<String>> getBookedSlots({
  required String barberId,
  required DateTime date,
}) async {
  final response = await _client
      .from('bookings')
      .select('time_slot')
      .eq('barber_id', barberId)
      .eq('booking_date', date.toIso8601String().split('T')[0])
      .neq('status', 'cancelled');

  return response
      .map<String>((e) => e['time_slot'] as String)
      .toList();
}
}
