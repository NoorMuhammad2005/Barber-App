// lib/widgets/shimmer_widgets.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_theme.dart';

// ─── Base Shimmer Box ─────────────────────────────────────────────────────

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated,
      highlightColor: AppColors.surfaceHighest,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// ─── Home Screen Skeleton ─────────────────────────────────────────────────

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          ShimmerBox(
            width: double.infinity,
            height: 180,
            borderRadius: 20,
          ),
          const SizedBox(height: 20),

          // Quick actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              4,
              (_) => Column(
                children: [
                  const ShimmerBox(width: 60, height: 60, borderRadius: 16),
                  const SizedBox(height: 6),
                  ShimmerBox(width: 40, height: 10),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          const ShimmerBox(width: 140, height: 22),
          const SizedBox(height: 12),

          // Service cards
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: ShimmerBox(
                  width: 260,
                  height: 90,
                  borderRadius: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          const ShimmerBox(width: 120, height: 22),
          const SizedBox(height: 12),

          // Barber cards
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: ShimmerBox(
                  width: 150,
                  height: 200,
                  borderRadius: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Services Skeleton ────────────────────────────────────────────────────

class ServicesShimmer extends StatelessWidget {
  const ServicesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: ShimmerBox(width: double.infinity, height: 120, borderRadius: 20),
      ),
    );
  }
}

// ─── Barbers Skeleton ─────────────────────────────────────────────────────

class BarbersShimmer extends StatelessWidget {
  const BarbersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: ShimmerBox(width: double.infinity, height: 320, borderRadius: 24),
      ),
    );
  }
}

// ─── Reviews Skeleton ─────────────────────────────────────────────────────

class ReviewsShimmer extends StatelessWidget {
  const ReviewsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated,
      highlightColor: AppColors.surfaceHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating summary
          Container(
            height: 140,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          // Review cards
          ...List.generate(
            4,
            (_) => Container(
              height: 140,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Booking Confirmation Skeleton ────────────────────────────────────────

class BookingConfirmShimmer extends StatelessWidget {
  const BookingConfirmShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated,
      highlightColor: AppColors.surfaceHighest,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.surfaceElevated,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 36,
              width: 220,
              color: AppColors.surfaceElevated,
              margin: const EdgeInsets.only(bottom: 12),
            ),
            Container(height: 16, width: 280, color: AppColors.surfaceElevated),
            const SizedBox(height: 32),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Profile Skeleton ─────────────────────────────────────────────────────

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated,
      highlightColor: AppColors.surfaceHighest,
      child: Column(
        children: [
          // Header
          Container(
            height: 220,
            color: AppColors.surfaceElevated,
          ),
          const SizedBox(height: 16),
          // Info tiles
          ...List.generate(
            4,
            (_) => Container(
              height: 64,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
