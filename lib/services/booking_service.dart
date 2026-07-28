import 'package:supabase_flutter/supabase_flutter.dart';

class BookingService {
  final _client = Supabase.instance.client;

  Future<void> createBooking({
  required String barberId,
  required String serviceId,
  required DateTime date,
  required String timeSlot,

  required String customerName,
  required String customerPhone,
  required String customerEmail,
  required double totalPrice,

  String notes = "",
}) async {
    final user = _client.auth.currentUser;
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

  'status': 'pending',

  'customer_name': customerName,

  'customer_phone': customerPhone,

  'customer_email': customerEmail,

  'total_price': totalPrice,

  'notes': notes,

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

Future<List<Map<String, dynamic>>> getAllBookings() async {
  final data = await _client
      .from('bookings')
      .select()
      .order('booking_date', ascending: true);

  return List<Map<String, dynamic>>.from(data);
}

Future<void> updateBookingStatus({
  required String bookingId,
  required String status,
}) async {
  await _client
      .from('bookings')
      .update({
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      })
      .eq('id', bookingId);
}
Future<void> cancelBooking(String bookingId) async {
  await _client
      .from('bookings')
      .update({
        'status': 'cancelled',
        'updated_at': DateTime.now().toIso8601String(),
      })
      .eq('id', bookingId);
}


}

