// lib/screens/barber_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';
import 'booking_screen.dart';

class BarberDetailScreen extends ConsumerWidget {
  final BarberModel barber;
  const BarberDetailScreen({super.key, required this.barber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(languageProvider) == 'ar';
    final reviews = ref.watch(reviewsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Sliver App Bar with barber photo ───────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary, size: 20),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share_rounded,
                      color: AppColors.textPrimary, size: 20),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Photo
                  Image.network(
                    barber.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceElevated,
                      child: const Icon(Icons.person,
                          color: AppColors.textMuted, size: 80),
                    ),
                  ),
                  // Gradient overlay
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          AppColors.background,
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  // Availability badge
                  Positioned(
                    top: 16,
                    right: 60,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: (barber.isAvailable
                                ? AppColors.success
                                : AppColors.error)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: barber.isAvailable
                              ? AppColors.success
                              : AppColors.error,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: barber.isAvailable
                                  ? AppColors.success
                                  : AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            barber.isAvailable
                                ? (isArabic ? 'متاح اليوم' : 'Available Today')
                                : (isArabic ? 'غير متاح' : 'Unavailable'),
                            style: GoogleFonts.raleway(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: barber.isAvailable
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & specialty
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? barber.nameAr : barber.name,
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              isArabic
                                  ? barber.specialtyAr
                                  : barber.specialty,
                              style: GoogleFonts.raleway(
                                fontSize: 14,
                                color: AppColors.textGold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).animate().fadeIn().slideY(begin: 0.1),

                  const SizedBox(height: 16),

                  // Rating row
                  Row(
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
                        '${barber.rating}',
                        style: GoogleFonts.raleway(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        ' (${barber.reviewCount} reviews)',
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ).animate(delay: 100.ms).fadeIn(),

                  const SizedBox(height: 20),

                  // Stats row
                  Row(
                    children: [
                      _statChip('🏆', '${barber.experienceYears}+',
                          isArabic ? 'سنوات' : 'Years'),
                      const SizedBox(width: 10),
                      _statChip('💈', '${barber.services.length}',
                          isArabic ? 'خدمات' : 'Services'),
                      const SizedBox(width: 10),
                      _statChip('⭐', '${barber.reviewCount}',
                          isArabic ? 'تقييمات' : 'Reviews'),
                    ],
                  ).animate(delay: 150.ms).fadeIn(),

                  const SizedBox(height: 24),
                  const GoldDivider(),
                  const SizedBox(height: 20),

                  // Bio
                  Text(
                    isArabic ? 'نبذة' : 'About',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    barber.bio,
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ).animate(delay: 200.ms).fadeIn(),

                  const SizedBox(height: 24),

                  // Work gallery (placeholder tiles)
                  Text(
                    isArabic ? 'معرض الأعمال' : 'Work Gallery',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                    ),
                    itemCount: 6,
                    itemBuilder: (_, i) {
                      final styles = ['✂️', '💈', '🪒', '💇', '✨', '🔥'];
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: AppColors.surfaceHighest),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(styles[i],
                                  style: const TextStyle(fontSize: 28)),
                            ),
                            Positioned(
                              bottom: 6,
                              left: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.background.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  ['Fade', 'Classic', 'Beard', 'Style', 'Facial', 'Shave'][i],
                                  style: GoogleFonts.raleway(
                                    fontSize: 8,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate(delay: (i * 60).ms).fadeIn().scale(
                            begin: const Offset(0.9, 0.9),
                          );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Recent Reviews
                  Text(
                    isArabic ? 'آراء العملاء' : 'Client Reviews',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...reviews.take(2).map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ReviewCard(review: r, isArabic: isArabic),
                        ),
                      ),

                  const SizedBox(height: 32),

                  // Book CTA
                  GoldButton(
                    label: isArabic
                        ? 'احجز مع ${barber.nameAr}'
                        : 'Book with ${barber.name}',
                    icon: Icons.calendar_today_rounded,
                    onTap: barber.isAvailable
                        ? () {
                            ref
                                .read(selectedBarberProvider.notifier)
                                .state = barber;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const BookingScreen()),
                            );
                          }
                        : () {},
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(String emoji, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.surfaceHighest),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
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
        ),
      ),
    );
  }
}
