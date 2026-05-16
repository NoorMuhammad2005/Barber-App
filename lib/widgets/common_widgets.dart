// lib/widgets/common_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../utils/app_theme.dart';
import '../models/models.dart';

// ─── Gold Gradient Button ─────────────────────────────────────────────────────
class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;
  final double? width;
  final double height;
  final IconData? icon;

  const GoldButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.width,
    this.height = 54,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: AppColors.goldGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: AppColors.background,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: AppColors.background, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label.toUpperCase(),
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.background,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? titleAr;
  final String? subtitle;
  final String? action;
  final VoidCallback? onAction;
  final bool isArabic;

  const SectionHeader({
    super.key,
    required this.title,
    this.titleAr,
    this.subtitle,
    this.action,
    this.onAction,
    this.isArabic = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle = isArabic && titleAr != null ? titleAr! : title;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  displayTitle,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
                style: GoogleFonts.raleway(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Barber Card ──────────────────────────────────────────────────────────────
class BarberCard extends StatelessWidget {
  final BarberModel barber;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isArabic;

  const BarberCard({
    super.key,
    required this.barber,
    required this.onTap,
    this.isSelected = false,
    this.isArabic = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 160,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E1E1E), Color(0xFF141414)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.surfaceHighest,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.gold
                            : AppColors.surfaceHighest,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        barber.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.surfaceHighest,
                          child: const Icon(
                            Icons.person,
                            color: AppColors.textMuted,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: barber.isAvailable
                            ? AppColors.success
                            : AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                isArabic ? barber.nameAr : barber.name,
                style: GoogleFonts.raleway(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                isArabic ? barber.specialtyAr : barber.specialty,
                style: GoogleFonts.raleway(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star_rounded,
                      color: AppColors.gold, size: 14),
                  const SizedBox(width: 3),
                  Text(
                    barber.rating.toStringAsFixed(1),
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${barber.reviewCount})',
                    style: GoogleFonts.raleway(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${barber.experienceYears}+ yrs',
                  style: GoogleFonts.raleway(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Service Card ─────────────────────────────────────────────────────────────
class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isArabic;
  final bool isCompact;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
    this.isSelected = false,
    this.isArabic = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E1E1E), Color(0xFF141414)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.surfaceHighest,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 14 : 20),
          child: isCompact ? _buildCompact() : _buildFull(),
        ),
      ),
    );
  }

  Widget _buildCompact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.goldGlow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(service.icon, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? service.nameAr : service.name,
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${service.durationMinutes} min',
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '£${service.price.toStringAsFixed(0)}',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.gold,
              ),
            ),
          ],
        ),
        if (service.isPopular) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.goldGlow,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'POPULAR',
              style: GoogleFonts.raleway(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.gold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFull() {
    return Column(
      crossAxisAlignment:
          isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.goldGlow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(service.icon, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: isArabic
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (service.isPopular)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.goldGlow,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'POPULAR',
                        style: GoogleFonts.raleway(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.gold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  Text(
                    isArabic ? service.nameAr : service.name,
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    isArabic ? service.descriptionAr : service.description,
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(color: AppColors.surfaceHighest, height: 1),
        const SizedBox(height: 16),
        Row(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Row(
              children: [
                const Icon(Icons.schedule_rounded,
                    size: 15, color: AppColors.textMuted),
                const SizedBox(width: 5),
                Text(
                  '${service.durationMinutes} min',
                  style: GoogleFonts.raleway(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              'From ',
              style: GoogleFonts.raleway(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
            Text(
              '£${service.price.toStringAsFixed(0)}',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.gold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Review Card ──────────────────────────────────────────────────────────────
class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final bool isArabic;

  const ReviewCard({super.key, required this.review, this.isArabic = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceHighest, width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
            isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(review.userAvatar),
                onBackgroundImageError: (_, __) {},
                backgroundColor: AppColors.surfaceHighest,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: isArabic
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (review.serviceUsed != null)
                      Text(
                        review.serviceUsed!,
                        style: GoogleFonts.raleway(
                          fontSize: 12,
                          color: AppColors.textGold,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RatingBarIndicator(
                    rating: review.rating,
                    itemBuilder: (_, __) => const Icon(
                      Icons.star_rounded,
                      color: AppColors.gold,
                    ),
                    itemCount: 5,
                    itemSize: 14,
                    unratedColor: AppColors.surfaceHighest,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(review.date),
                    style: GoogleFonts.raleway(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            isArabic ? review.commentAr : review.comment,
            style: GoogleFonts.raleway(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }
}

// ─── Gold Divider ─────────────────────────────────────────────────────────────
class GoldDivider extends StatelessWidget {
  const GoldDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.surfaceHighest, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.gold,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.surfaceHighest, thickness: 1),
        ),
      ],
    );
  }
}
