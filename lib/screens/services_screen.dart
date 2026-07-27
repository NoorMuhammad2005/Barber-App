// lib/screens/services_screen.dart
import 'package:barbershop_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';
import 'booking_screen.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(languageProvider) == 'ar';
    final services = ref.watch(servicesProvider);

    final categories = ['All', 'Hair', 'Beard', 'Shave', 'Facial', 'Color'];
    

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
          isArabic ? 'الخدمات' : 'Our Services',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Filter
          SizedBox(
            height: 46,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: categories.length,
              itemBuilder: (context, i) {
                final cat = categories[i];
                final isActive = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: 250.ms,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isActive ? AppColors.goldGradient : null,
                        color: isActive ? null : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isActive
                              ? Colors.transparent
                              : AppColors.surfaceHighest,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          fontWeight:
                              isActive ? FontWeight.w800 : FontWeight.w500,
                          color: isActive
                              ? AppColors.background
                              : AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

         Expanded(
  child: services.when(
    loading: () => const Center(
      child: CircularProgressIndicator(),
    ),

    error: (e, _) => Center(
      child: Text(e.toString()),
    ),

    data: (serviceList) {
      final filtered = _selectedCategory == 'All'
          ? serviceList
          : serviceList
              .where((s) => s['category'] == _selectedCategory)
              .toList();

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: filtered.length,
        itemBuilder: (context, i) {
          final service = ServiceModel.fromMap(filtered[i]);

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: ServiceCard(
              service: service,
              isArabic: isArabic,
              onTap: () {
                ref.read(selectedServiceProvider.notifier).state = service;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BookingScreen(),
                  ),
                );
              },
            ),
          )
              .animate(delay: (i * 80).ms)
              .slideY(
                begin: .15,
                duration: 350.ms,
              )
              .fadeIn();
        },
      );
    },
  ),
),
        ],
      ),
    );
  }
}
