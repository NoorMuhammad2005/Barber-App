// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utils/app_theme.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';
import 'booking_screen.dart';
import 'services_screen.dart';
import 'barbers_screen.dart';
import 'reviews_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _bannerController = PageController();
  int _currentBanner = 0;

  final List<Map<String, String>> _banners = [
    {
      'title': 'Book Your Haircut\nin Seconds',
      'titleAr': 'احجز قصتك\nفي ثوانٍ',
      'subtitle': 'Premium service. Zero wait.',
      'subtitleAr': 'خدمة فاخرة. بدون انتظار.',
      'tag': 'NEW APP',
    },
    {
      'title': 'Meet Our\nMaster Barbers',
      'titleAr': 'تعرف على\nحلاقينا المحترفين',
      'subtitle': '12+ years of crafted excellence',
      'subtitleAr': '12+ سنة من التميز',
      'tag': 'EXPERTS',
    },
    {
      'title': 'First Booking?\n20% OFF',
      'titleAr': 'حجزك الأول؟\nخصم 20%',
      'subtitle': 'Limited time offer for new members',
      'subtitleAr': 'عرض محدود للأعضاء الجدد',
      'tag': 'OFFER',
    },
  ];

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(languageProvider) == 'ar';
    final services = ref.watch(servicesProvider);
    final barbers = ref.watch(barbersProvider);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App Bar ──────────────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              backgroundColor: AppColors.background,
              elevation: 0,
              flexibleSpace: null,
              title: Row(
                textDirection:
                    isArabic ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  // Logo
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('✂️', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NOIR BARBER',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gold,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        isArabic ? 'لندن • الرياض' : 'London • Riyadh',
                        style: GoogleFonts.raleway(
                          fontSize: 10,
                          color: AppColors.textMuted,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Notification Bell
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: AppColors.textPrimary,
                          size: 26,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.gold,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // ── Hero Banner ────────────────────────────────────────────
                  _buildHeroBanner(isArabic).animate().fadeIn(
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 8),

                  // Page Indicator
                  Center(
                    child: SmoothPageIndicator(
                      controller: _bannerController,
                      count: _banners.length,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: AppColors.gold,
                        dotColor: AppColors.surfaceHighest,
                        dotHeight: 6,
                        dotWidth: 6,
                        expansionFactor: 3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Quick Actions ──────────────────────────────────────────
                  _buildQuickActions(context, isArabic)
                      .animate()
                      .slideY(
                        begin: 0.2,
                        duration: 500.ms,
                        delay: 200.ms,
                        curve: Curves.easeOut,
                      )
                      .fadeIn(delay: 200.ms),

                  const SizedBox(height: 32),

                  // ── Popular Services ───────────────────────────────────────
                  SectionHeader(
                    title: 'Popular Services',
                    titleAr: 'الخدمات الشائعة',
                    action: isArabic ? 'عرض الكل' : 'See All',
                    onAction: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ServicesScreen()),
                    ),
                    isArabic: isArabic,
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: services
                          .where((s) => s.isPopular)
                          .length,
                      itemBuilder: (context, i) {
                        final popularServices =
                            services.where((s) => s.isPopular).toList();
                        final service = popularServices[i];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: isArabic ? 0 : 12,
                            left: isArabic ? 12 : 0,
                          ),
                          child: ServiceCard(
                            service: service,
                            isSelected: false,
                            isArabic: isArabic,
                            isCompact: true,
                            onTap: () {
                              ref
                                  .read(selectedServiceProvider.notifier)
                                  .state = service;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const BookingScreen()),
                              );
                            },
                          ),
                        ).animate(delay: (i * 100).ms).slideX(
                              begin: isArabic ? 0.2 : -0.2,
                              duration: 400.ms,
                              curve: Curves.easeOut,
                            ).fadeIn(delay: (i * 100).ms);
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Our Barbers ────────────────────────────────────────────
                  SectionHeader(
                    title: 'Our Barbers',
                    titleAr: 'حلاقونا',
                    action: isArabic ? 'عرض الكل' : 'See All',
                    onAction: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BarbersScreen()),
                    ),
                    isArabic: isArabic,
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 210,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: barbers.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: isArabic ? 0 : 12,
                            left: isArabic ? 12 : 0,
                          ),
                          child: BarberCard(
                            barber: barbers[i],
                            isArabic: isArabic,
                            onTap: () {
                              ref
                                  .read(selectedBarberProvider.notifier)
                                  .state = barbers[i];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const BookingScreen()),
                              );
                            },
                          ),
                        ).animate(delay: (i * 100).ms).slideX(
                              begin: isArabic ? 0.2 : -0.2,
                              duration: 400.ms,
                              curve: Curves.easeOut,
                            ).fadeIn(delay: (i * 100).ms);
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Stats Row ──────────────────────────────────────────────
                  _buildStatsRow(isArabic),

                  const SizedBox(height: 32),

                  // ── Reviews ────────────────────────────────────────────────
                  SectionHeader(
                    title: 'What Clients Say',
                    titleAr: 'ما يقوله العملاء',
                    action: isArabic ? 'عرض الكل' : 'See All',
                    onAction: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ReviewsScreen()),
                    ),
                    isArabic: isArabic,
                  ),
                  const SizedBox(height: 16),
                  _buildReviewPreview(isArabic),

                  const SizedBox(height: 32),

                  // ── Book CTA ───────────────────────────────────────────────
                  _buildBookingCTA(context, isArabic),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner(bool isArabic) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _bannerController,
        onPageChanged: (i) => setState(() => _currentBanner = i),
        itemCount: _banners.length,
        itemBuilder: (context, i) {
          final banner = _banners[i];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1500), Color(0xFF0D0B00), Color(0xFF1E1E1E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: AppColors.goldDark.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: CustomPaint(
                        painter: _GridPatternPainter(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: isArabic
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.goldGlow,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppColors.gold.withOpacity(0.3)),
                          ),
                          child: Text(
                            banner['tag']!,
                            style: GoogleFonts.raleway(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.gold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isArabic ? banner['titleAr']! : banner['title']!,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                          textDirection: isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isArabic
                              ? banner['subtitleAr']!
                              : banner['subtitle']!,
                          style: GoogleFonts.raleway(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: isArabic ? null : 0,
                    left: isArabic ? 0 : null,
                    top: 0,
                    bottom: 0,
                    child: Opacity(
                      opacity: 0.15,
                      child: Text(
                        '✂️',
                        style: const TextStyle(fontSize: 120),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isArabic) {
    final actions = [
      {
        'icon': '📅',
        'label': isArabic ? 'حجز' : 'Book',
        'screen': const BookingScreen(),
      },
      {
        'icon': '💈',
        'label': isArabic ? 'الخدمات' : 'Services',
        'screen': const ServicesScreen(),
      },
      {
        'icon': '👨‍🦱',
        'label': isArabic ? 'الحلاقون' : 'Barbers',
        'screen': const BarbersScreen(),
      },
      {
        'icon': '⭐',
        'label': isArabic ? 'التقييمات' : 'Reviews',
        'screen': const ReviewsScreen(),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((action) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => action['screen'] as Widget),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(18),
                    border:
                        Border.all(color: AppColors.surfaceHighest, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      action['icon'] as String,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  action['label'] as String,
                  style: GoogleFonts.raleway(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsRow(bool isArabic) {
    final stats = [
      {
        'value': '4.9',
        'label': isArabic ? 'التقييم' : 'Rating',
        'icon': '⭐',
      },
      {
        'value': '2.4K+',
        'label': isArabic ? 'عميل' : 'Clients',
        'icon': '👤',
      },
      {
        'value': '12+',
        'label': isArabic ? 'سنة خبرة' : 'Yrs Exp.',
        'icon': '🏆',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.surfaceHighest),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          children: stats.asMap().entries.map((entry) {
            final i = entry.key;
            final stat = entry.value;
            return Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: i < stats.length - 1
                      ? Border(
                          right: BorderSide(
                            color: AppColors.surfaceHighest,
                          ),
                        )
                      : null,
                ),
                child: Column(
                  children: [
                    Text(stat['icon']!,
                        style: const TextStyle(fontSize: 22)),
                    const SizedBox(height: 6),
                    Text(
                      stat['value']!,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                      ),
                    ),
                    Text(
                      stat['label']!,
                      style: GoogleFonts.raleway(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildReviewPreview(bool isArabic) {
    final reviews = ref.watch(reviewsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ReviewCard(review: reviews.first, isArabic: isArabic),
    );
  }

  Widget _buildBookingCTA(BuildContext context, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GoldButton(
        label: isArabic ? 'احجز موعدك الآن' : 'Book Your Appointment',
        icon: Icons.calendar_today_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BookingScreen()),
        ),
      ),
    );
  }
}

class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withOpacity(0.05)
      ..strokeWidth = 0.5;

    const spacing = 30.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
