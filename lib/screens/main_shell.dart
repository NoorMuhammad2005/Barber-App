// lib/screens/main_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../providers/app_provider.dart';
import 'home_screen.dart';
import 'services_screen.dart';
import 'booking_screen.dart';
import 'location_screen.dart';
import 'profile_screen.dart';
import 'admin_screen.dart';

class MainShell extends ConsumerWidget {
  const MainShell({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);
   // final isArabic = ref.watch(languageProvider) == 'ar';

    final screens = [
      const HomeScreen(),
      const ServicesScreen(),
      const BookingScreen(),
   //   const LocationScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: _buildNavBar(context, ref, index, ),
    );
  }

  Widget _buildNavBar(
      BuildContext context, WidgetRef ref, int currentIndex, ) {
    final items = [
      (Icons.home_rounded, Icons.home_outlined, 'Home'),
      (
        Icons.content_cut_rounded,
        Icons.content_cut_outlined,
        'Services'
      ),
      (
        Icons.calendar_today_rounded,
        Icons.calendar_today_outlined,
        'Book'
      ),
      // (
      //   Icons.location_on_rounded,
      //   Icons.location_on_outlined,
      //   'Location'
      // ),
      (
        Icons.person_rounded,
        Icons.person_outlined,
        'Profile'
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.surfaceHighest, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...items.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                final isActive = currentIndex == i;

                // Book button (center) is special
                if (i == 2) {
                  return GestureDetector(
                    onTap: () =>
                        ref.read(bottomNavIndexProvider.notifier).state = i,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        item.$1,
                        color: AppColors.background,
                        size: 26,
                      ),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () =>
                      ref.read(bottomNavIndexProvider.notifier).state = i,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.goldGlow : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActive ? item.$1 : item.$2,
                          color:
                              isActive ? AppColors.gold : AppColors.textMuted,
                          size: 24,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.$3,
                          style: GoogleFonts.raleway(
                            fontSize: 10,
                            fontWeight:
                                isActive ? FontWeight.w700 : FontWeight.w500,
                            color:
                                isActive ? AppColors.gold : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // Admin button
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminScreen()),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: AppColors.textMuted,
                        size: 24,
                      ),
                      const SizedBox(height: 3),
                      Text(
                         'Admin',
                        style: GoogleFonts.raleway(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
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
    );
  }
}
