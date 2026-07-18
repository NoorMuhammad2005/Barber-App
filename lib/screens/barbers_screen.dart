// lib/screens/barbers_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';
import 'booking_screen.dart';

class BarbersScreen extends ConsumerWidget {
  const BarbersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(languageProvider) == 'ar';
    final barbers = ref.watch(barbersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isArabic ? 'حلاقونا' : 'Our Barbers',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        itemCount: barbers.length,
        itemBuilder: (context, i) {
          final barber = barbers[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.surfaceHighest),
              ),
              child: Column(
                children: [
                  // Header image area
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.goldDark.withValues(alpha: 0.2),
                          AppColors.background,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24)),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(24)),
                            child: CustomPaint(
                              painter: _DiamondPatternPainter(),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.gold, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gold.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.network(
                                barber.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.surfaceHighest,
                                  child: const Icon(Icons.person,
                                      color: AppColors.textMuted, size: 44),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (!barber.isAvailable)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppColors.error.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                isArabic ? 'غير متاح اليوم' : 'Unavailable Today',
                                style: GoogleFonts.raleway(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          isArabic ? barber.nameAr : barber.name,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isArabic ? barber.specialtyAr : barber.specialty,
                          style: GoogleFonts.raleway(
                            fontSize: 13,
                            color: AppColors.textGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingBarIndicator(
                              rating: barber.rating,
                              itemBuilder: (_, __) => const Icon(
                                Icons.star_rounded,
                                color: AppColors.gold,
                              ),
                              itemCount: 5,
                              itemSize: 18,
                              unratedColor: AppColors.surfaceHighest,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${barber.rating} (${barber.reviewCount} reviews)',
                              style: GoogleFonts.raleway(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statItem('${barber.experienceYears}+',
                                isArabic ? 'سنوات' : 'Years', '🏆'),
                            Container(
                                width: 1,
                                height: 40,
                                color: AppColors.surfaceHighest),
                            _statItem('${barber.reviewCount}',
                                isArabic ? 'تقييم' : 'Reviews', '⭐'),
                            Container(
                                width: 1,
                                height: 40,
                                color: AppColors.surfaceHighest),
                            _statItem(
                                '${barber.services.length}',
                                isArabic ? 'خدمات' : 'Services',
                                '💈'),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          barber.bio,
                          style: GoogleFonts.raleway(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 20),

                        GoldButton(
                          label: isArabic ? 'احجز مع ${barber.nameAr}' : 'Book with ${barber.name}',
                          onTap: barber.isAvailable
                              ? () {
                                  ref
                                      .read(selectedBarberProvider.notifier)
                                      .state = barber;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const BookingScreen()),
                                  );
                                }
                              : () {},
                          height: 48,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate(delay: (i * 100).ms).fadeIn().slideY(begin: 0.1);
        },
      ),
    );
  }

  Widget _statItem(String value, String label, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.gold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.raleway(
            fontSize: 11,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _DiamondPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const s = 24.0;
    for (double x = 0; x < size.width + s; x += s) {
      for (double y = 0; y < size.height + s; y += s) {
        final path = Path()
          ..moveTo(x, y - s / 2)
          ..lineTo(x + s / 2, y)
          ..lineTo(x, y + s / 2)
          ..lineTo(x - s / 2, y)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
