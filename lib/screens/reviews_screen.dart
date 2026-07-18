// lib/screens/reviews_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';

class ReviewsScreen extends ConsumerWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(languageProvider) == 'ar';
    final reviews = ref.watch(reviewsProvider);

    final avgRating = reviews.fold(0.0, (s, r) => s + r.rating) / reviews.length;

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
          isArabic ? 'التقييمات' : 'Reviews',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Overall Rating Card
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A1500), Color(0xFF1E1E1E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: AppColors.goldDark.withValues(alpha: 0.3)),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              avgRating.toStringAsFixed(1),
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 56,
                                fontWeight: FontWeight.w700,
                                color: AppColors.gold,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            RatingBarIndicator(
                              rating: avgRating,
                              itemBuilder: (_, __) => const Icon(
                                Icons.star_rounded,
                                color: AppColors.gold,
                              ),
                              itemCount: 5,
                              itemSize: 20,
                              unratedColor: AppColors.surfaceHighest,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${reviews.length} ${isArabic ? 'تقييم' : 'reviews'}',
                              style: GoogleFonts.raleway(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            children: [5, 4, 3, 2, 1].map((star) {
                              final count = reviews
                                  .where((r) => r.rating.round() == star)
                                  .length;
                              final pct = reviews.isEmpty
                                  ? 0.0
                                  : count / reviews.length;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    Text(
                                      '$star',
                                      style: GoogleFonts.raleway(
                                        fontSize: 11,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.star_rounded,
                                        color: AppColors.gold, size: 12),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: pct,
                                          backgroundColor:
                                              AppColors.surfaceHighest,
                                          valueColor:
                                              const AlwaysStoppedAnimation(
                                                  AppColors.gold),
                                          minHeight: 6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: 0.1),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: ReviewCard(
                      review: reviews[i],
                      isArabic: isArabic,
                    ),
                  ).animate(delay: (i * 80).ms).fadeIn().slideY(begin: 0.1);
                },
                childCount: reviews.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
