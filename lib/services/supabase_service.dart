// lib/services/supabase_service.dart
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase service layer — wire up your real keys to go live.
class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  // ─── Auth ──────────────────────────────────────────────────────────────────

  static Future<AuthResponse> signInWithEmail(
      String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<AuthResponse> signUpWithEmail(
      String email, String password, String name) async {
    final res = await client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );
    return res;
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static User? get currentUser => client.auth.currentUser;

  // ─── Services ──────────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> fetchServices() async {
    final response = await client
        .from('services')
        .select()
        .order('is_popular', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> addService(Map<String, dynamic> data) async {
    await client.from('services').insert(data);
  }

  static Future<void> updateService(
      String id, Map<String, dynamic> data) async {
    await client.from('services').update(data).eq('id', id);
  }

  static Future<void> deleteService(String id) async {
    await client.from('services').delete().eq('id', id);
  }

  // ─── Barbers ───────────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> fetchBarbers() async {
    final response =
        await client.from('barbers').select().order('rating', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // ─── Bookings ──────────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> fetchBookings(String userId) async {
    final response = await client
        .from('bookings')
        .select('*, services(*), barbers(*)')
        .eq('user_id', userId)
        .order('date', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> createBooking(Map<String, dynamic> data) async {
    await client.from('bookings').insert({
      ...data,
      'user_id': currentUser?.id,
      'status': 'confirmed',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> cancelBooking(String bookingId) async {
    await client
        .from('bookings')
        .update({'status': 'cancelled'}).eq('id', bookingId);
  }

  /// Realtime subscription for live booking updates.
  static RealtimeChannel subscribeToBookings(
    String userId,
    void Function(Map<String, dynamic>) onUpdate,
  ) {
    return client
        .channel('bookings:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'bookings',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) => onUpdate(payload.newRecord),
        )
        .subscribe();
  }

  // ─── Reviews ───────────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> fetchReviews() async {
    final response = await client
        .from('reviews')
        .select('*, users(name, avatar_url)')
        .order('created_at', ascending: false)
        .limit(20);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> submitReview(
      String bookingId, double rating, String comment) async {
    await client.from('reviews').insert({
      'booking_id': bookingId,
      'user_id': currentUser?.id,
      'rating': rating,
      'comment': comment,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // ─── Availability ──────────────────────────────────────────────────────────

  static Future<List<String>> fetchBookedSlots(
      String barberId, DateTime date) async {
    final response = await client
        .from('bookings')
        .select('time_slot')
        .eq('barber_id', barberId)
        .eq('date', date.toIso8601String().split('T')[0])
        .neq('status', 'cancelled');
    return (response as List).map((r) => r['time_slot'] as String).toList();
  }

  // ─── Storage ───────────────────────────────────────────────────────────────

//   static Future<String?> uploadBarberImage(
//       String barberId, List<int> bytes, String ext) async {
//     final path = 'barbers/$barberId.$ext';
//     await client.storage
//         .from('avatars')
//         .uploadBinary(path, bytes, fileOptions: FileOptions(upsert: true));
//     return client.storage.from('avatars').getPublicUrl(path);
//   }

//   static Future<String?> uploadUserAvatar(
//       String userId, List<int> bytes, String ext) async {
//     final path = 'users/$userId.$ext';
//     await client.storage
//         .from('avatars')
//         .uploadBinary(path, bytes, fileOptions: FileOptions(upsert: true));
//     return client.storage.from('avatars').getPublicUrl(path);
//   }
// }

  static Future<String?> uploadBarberImage(
      String barberId, Uint8List bytes, String ext) async {
    final path = 'barbers/$barberId.$ext';

    await client.storage.from('avatars').uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    return client.storage.from('avatars').getPublicUrl(path);
  }

  static Future<String?> uploadUserAvatar(
      String userId, Uint8List bytes, String ext) async {
    final path = 'users/$userId.$ext';

    await client.storage.from('avatars').uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    return client.storage.from('avatars').getPublicUrl(path);
  }
}
