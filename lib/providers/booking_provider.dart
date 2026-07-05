import 'package:flutter_riverpod/flutter_riverpod.dart';
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