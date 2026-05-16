// lib/screens/loyalty_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../utils/app_theme.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';

class LoyaltyScreen extends ConsumerWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(languageProvider) == 'ar';

    const currentPoints = 340;
    const nextTierPoints = 500;
    const pct = currentPoints / nextTierPoints;

    final rewards = [
      _Reward(
        icon: '✂️',
        title: isArabic ? 'قصة شعر مجانية' : 'Free Haircut',
        points: 500,
        isUnlocked: false,
      ),
      _Reward(
        icon: '🪒',
        title: isArabic ? 'خصم 20% على الحجز' : '20% Off Any Booking',
        points: 200,
        isUnlocked: true,
      ),
      _Reward(
        icon: '🔥',
        title: isArabic ? 'حلاقة بمنشفة ساخنة مجانية' : 'Free Hot Towel Shave',
        points: 350,
        isUnlocked: false,
      ),
      _Reward(
        icon: '✨',
        title: isArabic ? 'عناية بالوجه مجانية' : 'Free Facial Treatment',
        points: 600,
        isUnlocked: false,
      ),
    ];

    final history = [
      _PointEvent(
        label: isArabic ? 'قصة شعر كلاسيكية' : 'Classic Haircut',
        points: 25,
        isEarned: true,
        date: '2 days ago',
      ),
      _PointEvent(
        label: isArabic ? 'تشذيب اللحية' : 'Beard Trim',
        points: 18,
        isEarned: true,
        date: '1 week ago',
      ),
      _PointEvent(
        label: isArabic ? 'استبدال مكافأة' : 'Reward Redeemed',
        points: 200,
        isEarned: false,
        date: '2 weeks ago',
      ),
    ];

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
          isArabic ? 'نقاط الولاء' : 'Loyalty Rewards',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Points Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1500), Color(0xFF0d0b00), Color(0xFF1E1E1E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: AppColors.goldDark.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'نقاطك' : 'Your Points',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              color: AppColors.textMuted,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            '$currentPoints',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 52,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gold,
                              height: 1,
                            ),
                          ),
                          Text(
                            isArabic ? 'نقطة' : 'points',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CircularPercentIndicator(
                            radius: 44,
                            lineWidth: 6,
                            percent: pct,
                            center: Text(
                              '${(pct * 100).toInt()}%',
                              style: GoogleFonts.raleway(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.gold,
                              ),
                            ),
                            progressColor: AppColors.gold,
                            backgroundColor: AppColors.surfaceHighest,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isArabic ? 'لمستوى الذهب' : 'To Gold Tier',
                            style: GoogleFonts.raleway(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: AppColors.surfaceHighest,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.gold),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$currentPoints pts',
                        style: GoogleFonts.raleway(
                          fontSize: 11,
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${nextTierPoints - currentPoints} pts ${isArabic ? 'متبقية للترقية' : 'to next tier'}',
                        style: GoogleFonts.raleway(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        '$nextTierPoints pts',
                        style: GoogleFonts.raleway(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.1),

            const SizedBox(height: 28),

            // Tiers
            Text(
              isArabic ? 'مستويات العضوية' : 'Membership Tiers',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: 12),

            Row(
              children: [
                _tierChip('Bronze', '0–199', '🥉', false),
                const SizedBox(width: 8),
                _tierChip('Silver', '200–499', '🥈', true),
                const SizedBox(width: 8),
                _tierChip('Gold', '500+', '🥇', false),
              ],
            ).animate(delay: 150.ms).fadeIn(),

            const SizedBox(height: 28),

            // Available Rewards
            Text(
              isArabic ? 'المكافآت المتاحة' : 'Available Rewards',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 12),

            ...rewards.asMap().entries.map((entry) {
              final i = entry.key;
              final r = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _rewardCard(r, isArabic),
              ).animate(delay: (250 + i * 60).ms).fadeIn().slideX(begin: 0.1);
            }),

            const SizedBox(height: 24),

            // Points History
            Text(
              isArabic ? 'سجل النقاط' : 'Points History',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ).animate(delay: 400.ms).fadeIn(),

            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.surfaceHighest),
              ),
              child: Column(
                children: history.asMap().entries.map((entry) {
                  final i = entry.key;
                  final event = entry.value;
                  return Column(
                    children: [
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: (event.isEarned
                                    ? AppColors.success
                                    : AppColors.error)
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            event.isEarned
                                ? Icons.add_rounded
                                : Icons.remove_rounded,
                            color: event.isEarned
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                        title: Text(
                          event.label,
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          event.date,
                          style: GoogleFonts.raleway(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                        trailing: Text(
                          '${event.isEarned ? '+' : '-'}${event.points} pts',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: event.isEarned
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ),
                      if (i < history.length - 1)
                        const Divider(
                            color: AppColors.surfaceHighest,
                            height: 1,
                            indent: 16,
                            endIndent: 16),
                    ],
                  );
                }).toList(),
              ),
            ).animate(delay: 500.ms).fadeIn(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _tierChip(
      String label, String range, String emoji, bool isCurrent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              isCurrent ? AppColors.goldGlow : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCurrent
                ? AppColors.gold
                : AppColors.surfaceHighest,
            width: isCurrent ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.raleway(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isCurrent
                    ? AppColors.gold
                    : AppColors.textSecondary,
              ),
            ),
            Text(
              range,
              style: GoogleFonts.raleway(
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rewardCard(_Reward r, bool isArabic) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: r.isUnlocked
              ? AppColors.gold.withOpacity(0.3)
              : AppColors.surfaceHighest,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: r.isUnlocked
                  ? AppColors.goldGlow
                  : AppColors.surfaceHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(r.icon,
                  style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.title,
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: r.isUnlocked
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.stars_rounded,
                        color: AppColors.gold, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${r.points} pts',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: AppColors.textGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          r.isUnlocked
              ? Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isArabic ? 'استبدل' : 'Redeem',
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.background,
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.textMuted, size: 18),
                ),
        ],
      ),
    );
  }
}

class _Reward {
  final String icon;
  final String title;
  final int points;
  final bool isUnlocked;
  const _Reward({
    required this.icon,
    required this.title,
    required this.points,
    required this.isUnlocked,
  });
}

class _PointEvent {
  final String label;
  final int points;
  final bool isEarned;
  final String date;
  const _PointEvent({
    required this.label,
    required this.points,
    required this.isEarned,
    required this.date,
  });
}
