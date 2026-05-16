// lib/providers/app_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

// ─── Language Provider ───────────────────────────────────────────────────────
final languageProvider = StateProvider<String>((ref) => 'en');

// ─── Demo Data ───────────────────────────────────────────────────────────────
final servicesProvider = Provider<List<ServiceModel>>((ref) => [
  const ServiceModel(
    id: 's1',
    name: 'Classic Haircut',
    nameAr: 'قصة شعر كلاسيكية',
    description: 'Precision cut tailored to your style',
    descriptionAr: 'قصة دقيقة مصممة وفق أسلوبك',
    price: 25,
    durationMinutes: 30,
    icon: '✂️',
    category: 'Hair',
    isPopular: true,
  ),
  const ServiceModel(
    id: 's2',
    name: 'Beard Trim & Shape',
    nameAr: 'تشذيب اللحية وتشكيلها',
    description: 'Expert beard shaping and grooming',
    descriptionAr: 'تشكيل احترافي وعناية باللحية',
    price: 18,
    durationMinutes: 20,
    icon: '🪒',
    category: 'Beard',
    isPopular: true,
  ),
  const ServiceModel(
    id: 's3',
    name: 'Hair Styling',
    nameAr: 'تصفيف الشعر',
    description: 'Premium styling with top products',
    descriptionAr: 'تصفيف فاخر بأفضل المنتجات',
    price: 35,
    durationMinutes: 45,
    icon: '💈',
    category: 'Hair',
  ),
  const ServiceModel(
    id: 's4',
    name: 'Luxury Facial',
    nameAr: 'عناية فاخرة بالوجه',
    description: 'Deep cleanse and rejuvenation',
    descriptionAr: 'تنظيف عميق وتجديد للبشرة',
    price: 45,
    durationMinutes: 60,
    icon: '✨',
    category: 'Facial',
  ),
  const ServiceModel(
    id: 's5',
    name: 'Hot Towel Shave',
    nameAr: 'حلاقة بالمنشفة الساخنة',
    description: 'Traditional straight razor shave',
    descriptionAr: 'حلاقة تقليدية بالموس المستقيم',
    price: 30,
    durationMinutes: 40,
    icon: '🔥',
    category: 'Shave',
    isPopular: true,
  ),
  const ServiceModel(
    id: 's6',
    name: 'Color & Highlights',
    nameAr: 'تلوين وهايلايت',
    description: 'Full color or partial highlights',
    descriptionAr: 'تلوين كامل أو هايلايت جزئي',
    price: 65,
    durationMinutes: 90,
    icon: '🎨',
    category: 'Color',
  ),
]);

final barbersProvider = Provider<List<BarberModel>>((ref) => [
  const BarberModel(
    id: 'b1',
    name: 'James Harrison',
    nameAr: 'جيمس هاريسون',
    specialty: 'Master Barber & Stylist',
    specialtyAr: 'حلاق ماستر ومصفف شعر',
    rating: 4.9,
    reviewCount: 312,
    experienceYears: 12,
    imageUrl: 'https://i.pravatar.cc/300?img=11',
    services: ['s1', 's2', 's3', 's5'],
    bio: 'Award-winning master barber with 12+ years crafting iconic looks for clients worldwide.',
    isAvailable: true,
  ),
  const BarberModel(
    id: 'b2',
    name: 'Marcus Williams',
    nameAr: 'ماركوس وليامز',
    specialty: 'Fade Specialist',
    specialtyAr: 'متخصص الفيد',
    rating: 4.8,
    reviewCount: 245,
    experienceYears: 8,
    imageUrl: 'https://i.pravatar.cc/300?img=12',
    services: ['s1', 's2', 's4'],
    bio: 'Precision fade specialist known for clean lines and modern cuts.',
    isAvailable: true,
  ),
  const BarberModel(
    id: 'b3',
    name: 'Khalid Al-Rashid',
    nameAr: 'خالد الراشد',
    specialty: 'Beard Artist',
    specialtyAr: 'فنان اللحية',
    rating: 4.9,
    reviewCount: 189,
    experienceYears: 10,
    imageUrl: 'https://i.pravatar.cc/300?img=33',
    services: ['s2', 's4', 's5'],
    bio: 'Beard artistry master specializing in traditional and contemporary styles.',
    isAvailable: false,
  ),
  const BarberModel(
    id: 'b4',
    name: 'Daniel Stone',
    nameAr: 'دانيال ستون',
    specialty: 'Color & Texture Expert',
    specialtyAr: 'خبير الألوان والملمس',
    rating: 4.7,
    reviewCount: 134,
    experienceYears: 6,
    imageUrl: 'https://i.pravatar.cc/300?img=15',
    services: ['s3', 's6'],
    bio: 'Creative colorist and texture specialist bringing bold visions to life.',
    isAvailable: true,
  ),
]);

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
