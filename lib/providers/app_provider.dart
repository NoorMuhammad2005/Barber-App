// lib/providers/app_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

// ─── Language Provider ───────────────────────────────────────────────────────
final languageProvider = StateProvider<String>((ref) => 'en');

// ─── Demo Data ───────────────────────────────────────────────────────────────
final servicesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {

  final client = Supabase.instance.client;

  final data = await client
      .from('services')
      .select()
      .eq('is_active', true)
      .order('name');

  return List<Map<String, dynamic>>.from(data);

});

final barbersProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final client = Supabase.instance.client;

  final data = await client
      .from('barbers')
      .select()
      .eq('is_active', true)
      .order('name');

  return List<Map<String, dynamic>>.from(data);
});

final reviewsProvider = Provider<List<ReviewModel>>((ref) => [
  ReviewModel(
    id: 'r1',
    userName: 'Oliver Bennett',
    userAvatar: 'https://i.pravatar.cc/100?img=20',
    rating: 5.0,
    comment: 'Best barber experience I\'ve ever had. James knew exactly what I wanted and delivered perfection. The atmosphere is unreal — dark, moody, premium.',
    commentAr: 'أفضل تجربة حلاقة على الإطلاق. جيمس عرف بالضبط ما أريد وقدم الكمال.',
    date: DateTime.now().subtract(const Duration(days: 2)),
    serviceUsed: 'Classic Haircut',
  ),
  ReviewModel(
    id: 'r2',
    userName: 'Ahmed Al-Farsi',
    userAvatar: 'https://i.pravatar.cc/100?img=21',
    rating: 5.0,
    comment: 'Khalid\'s beard shaping is next level. I drive 40 minutes just to come here. Worth every penny and then some.',
    commentAr: 'تشكيل لحية خالد في مستوى آخر. أقود 40 دقيقة فقط لأتي هنا. يستحق كل فلس.',
    date: DateTime.now().subtract(const Duration(days: 5)),
    serviceUsed: 'Beard Trim & Shape',
  ),
  ReviewModel(
    id: 'r3',
    userName: 'Thomas Reid',
    userAvatar: 'https://i.pravatar.cc/100?img=22',
    rating: 4.5,
    comment: 'Fantastic hot towel shave. Felt like royalty. The shop has incredible vibes — every detail is thought through.',
    commentAr: 'حلاقة رائعة بالمنشفة الساخنة. شعرت بالملوكية.',
    date: DateTime.now().subtract(const Duration(days: 8)),
    serviceUsed: 'Hot Towel Shave',
  ),
  ReviewModel(
    id: 'r4',
    userName: 'Mohammed Qasim',
    userAvatar: 'https://i.pravatar.cc/100?img=23',
    rating: 5.0,
    comment: 'Visited from Riyadh and this is by far the most professional barber shop I\'ve seen outside Saudi. Outstanding service!',
    commentAr: 'زرت من الرياض وهذا بالتأكيد أكثر محل حلاقة احترافية رأيته خارج السعودية.',
    date: DateTime.now().subtract(const Duration(days: 12)),
    serviceUsed: 'Classic Haircut',
  ),
  ReviewModel(
    id: 'r5',
    userName: 'Jack Morrison',
    userAvatar: 'https://i.pravatar.cc/100?img=24',
    rating: 4.5,
    comment: 'The online booking is seamless and the reminders are helpful. Marcus does a clean fade every single time.',
    commentAr: 'الحجز الإلكتروني سلس والتذكيرات مفيدة.',
    date: DateTime.now().subtract(const Duration(days: 15)),
    serviceUsed: 'Hair Styling',
  ),
]);

// ─── Selected Barber Provider ─────────────────────────────────────────────────
final selectedBarberProvider = StateProvider<BarberModel?>((ref) => null);

// ─── Selected Service Provider ────────────────────────────────────────────────
final selectedServiceProvider = StateProvider<ServiceModel?>((ref) => null);

// ─── Selected Date Provider ───────────────────────────────────────────────────
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// ─── Time Slots Provider ──────────────────────────────────────────────────────
final timeSlotsProvider = Provider<List<TimeSlot>>((ref) => [
  const TimeSlot(time: '09:00 AM', isAvailable: false),
  const TimeSlot(time: '10:00 AM', isAvailable: true),
  const TimeSlot(time: '11:00 AM', isAvailable: false),
  const TimeSlot(time: '12:00 PM', isAvailable: true),
  const TimeSlot(time: '01:00 PM', isAvailable: true),
  const TimeSlot(time: '02:00 PM', isAvailable: false),
  const TimeSlot(time: '03:00 PM', isAvailable: true),
  const TimeSlot(time: '04:00 PM', isAvailable: true),
  const TimeSlot(time: '05:00 PM', isAvailable: false),
  const TimeSlot(time: '06:00 PM', isAvailable: true),
]);

final selectedTimeSlotProvider = StateProvider<TimeSlot?>((ref) => null);

// ─── Bottom Nav Index ─────────────────────────────────────────────────────────
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// ─── Booking History ──────────────────────────────────────────────────────────
final bookingHistoryProvider = StateProvider<List<BookingModel>>((ref) => [
  BookingModel(
    id: 'bk1',
    serviceId: 's1',
    serviceName: 'Classic Haircut',
    barberId: 'b1',
    barberName: 'James Harrison',
    date: DateTime.now().subtract(const Duration(days: 7)),
    timeSlot: '11:00 AM',
    price: 25,
    status: BookingStatus.completed,
  ),
  BookingModel(
    id: 'bk2',
    serviceId: 's2',
    serviceName: 'Beard Trim & Shape',
    barberId: 'b2',
    barberName: 'Marcus Williams',
    date: DateTime.now().add(const Duration(days: 2)),
    timeSlot: '03:00 PM',
    price: 18,
    status: BookingStatus.confirmed,
  ),
]);

// ─── My Bookings Provider ─────────────────────────────────────

final myBookingsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final client = Supabase.instance.client;

  final user = client.auth.currentUser;

  if (user == null) {
    return [];
  }

  final data = await client
      .from('bookings')
      .select('''
        *,
        services(name,price),
        barbers(name,image_url)
      ''')
      .eq('user_id', user.id)
      .order('booking_date', ascending: false);

  return List<Map<String, dynamic>>.from(data);
});
