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
      'subtitle': 'Premium service. Zero wait.',
      'tag': 'NEW APP',
    },
    {
      'title': 'Meet Our\nMaster Barbers',
      'subtitle': '12+ years of crafted excellence',
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
  floating: true,
  pinned: true,
  elevation: 0,
  toolbarHeight: 72,
  backgroundColor: const Color(0xFF111111),

  titleSpacing: 20,

  title: Row(
    children: [
      Hero(
        tag: "logo",
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withOpacity(.30),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "✂️",
              style: TextStyle(fontSize: 22),
            ),
          ),
        ),
      ),

      const SizedBox(width: 14),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              "NOIR BARBER",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: AppColors.gold,
              ),
            ),

            const SizedBox(height: 2),

            Row(
              children: [

                Icon(
                  Icons.location_on_rounded,
                  color: AppColors.gold.withOpacity(.85),
                  size: 12,
                ),

                const SizedBox(width: 4),

                Text(
                  isArabic
                      ? "لندن • الرياض"
                      : "London ",
                  style: GoogleFonts.raleway(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.surfaceHighest,
          ),
        ),
        child: Stack(
          children: [

            Center(
              child: IconButton(
                splashRadius: 22,
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),

            Positioned(
              top: 11,
              right: 11,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),

           SliverToBoxAdapter(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const SizedBox(height: 16),

      // Hero Banner
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _buildHeroBanner(isArabic)
            .animate()
            .fadeIn(
              duration: 700.ms,
              curve: Curves.easeOut,
            )
            .slideY(
              begin: .15,
              duration: 700.ms,
              curve: Curves.easeOut,
            ),
      ),

      const SizedBox(height: 16),

      // Page Indicator
      Center(
        child: SmoothPageIndicator(
          controller: _bannerController,
          count: _banners.length,
          effect: ExpandingDotsEffect(
            activeDotColor: AppColors.gold,
            dotColor: AppColors.surfaceHighest.withOpacity(.6),
            dotHeight: 7,
            dotWidth: 7,
            expansionFactor: 4,
            spacing: 8,
            radius: 20,
          ),
        ),
      ),

      const SizedBox(height: 36),

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

const SizedBox(height: 40),

// ───────────────── Popular Services ─────────────────
Container(
  margin: const EdgeInsets.symmetric(horizontal: 20),
  padding: const EdgeInsets.symmetric(
    horizontal: 18,
    vertical: 20,
  ),
  decoration: BoxDecoration(
    color: AppColors.surfaceElevated,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: AppColors.gold.withOpacity(.18),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(.30),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SectionHeader(
        title: 'Popular Services',
        titleAr: 'الخدمات الشائعة',
        action: isArabic ? 'عرض الكل' : 'See All',
        onAction: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ServicesScreen(),
            ),
          );
        },
        isArabic: isArabic,
      ),

      const SizedBox(height: 20),

      SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount:
              services.where((s) => s.isPopular).length,
          itemBuilder: (context, i) {
            final popularServices =
                services.where((s) => s.isPopular).toList();

            final service = popularServices[i];

            return Padding(
              padding: EdgeInsets.only(
                right: isArabic ? 0 : 14,
                left: isArabic ? 14 : 0,
              ),
              child: SizedBox(
                width: 245,
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
                        builder: (_) => const BookingScreen(),
                      ),
                    );
                  },
                ),
              )
                  .animate(delay: (i * 100).ms)
                  .fadeIn()
                  .slideX(
                    begin: 0.25,
                    duration: 500.ms,
                    curve: Curves.easeOut,
                  ),
            );
          },
        ),
      ),
    ],
  ),
).animate().fadeIn().slideY(begin: .15),

const SizedBox(height: 40),

                  // ── Our Barbers ────────────────────────────────────────────
                SectionHeader(
  title: 'Our Barbers',
  titleAr: 'حلاقونا',
  action: isArabic ? 'عرض الكل' : 'See All',
  onAction: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const BarbersScreen(),
    ),
  ),
  isArabic: isArabic,
),

const SizedBox(height: 18),

SizedBox(
  height: 245,
  child: ListView.separated(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    scrollDirection: Axis.horizontal,
    itemCount: barbers.length,
    separatorBuilder: (_, __) => const SizedBox(width: 16),
    itemBuilder: (context, i) {
      final barber = barbers[i];

      return SizedBox(
        width: 185,
        child: BarberCard(
          barber: barber,
          isArabic: isArabic,
          onTap: () {
            ref.read(selectedBarberProvider.notifier).state = barber;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const BookingScreen(),
              ),
            );
          },
        ),
      )
          .animate(delay: (i * 120).ms)
          .fadeIn(duration: 500.ms)
          .slideX(
            begin: .25,
            curve: Curves.easeOutCubic,
          )
          .scale(
            begin: const Offset(.92, .92),
            curve: Curves.easeOutBack,
          );
    },
  ),
),

const SizedBox(height: 36),

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
                border: Border.all(color: AppColors.goldDark.withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.1),
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
                                color: AppColors.gold.withValues(alpha: 0.3)),
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
                    child: const Opacity(
                      opacity: 0.15,
                      child: Text(
                        '✂️',
                        style: TextStyle(fontSize: 120),
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
                      ? const Border(
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
      ..color = AppColors.gold.withValues(alpha: 0.05)
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
