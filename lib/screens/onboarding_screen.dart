// lib/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  final _pages = [
    const _OnboardPage(
      emoji: '✂️',
      tag: 'PREMIUM CUTS',
      title: 'Master Barbers\nat Your Fingertips',
      subtitle:
          'Book with award-winning barbers who have shaped icons across London, Riyadh and Dubai.',
      bgColor: Color(0xFF1A1500),
      accentColor: AppColors.gold,
    ),
    const _OnboardPage(
      emoji: '📅',
      tag: 'INSTANT BOOKING',
      title: 'Book in Seconds,\nNot Minutes',
      subtitle:
          'Pick your service, choose a time slot that works for you, select your barber — done.',
      bgColor: Color(0xFF001A0D),
      accentColor: Color(0xFF2ECC71),
    ),
    const _OnboardPage(
      emoji: '💳',
      tag: 'SECURE PAYMENTS',
      title: 'Pay Safely\nOnline or In Store',
      subtitle:
          'Card, Apple Pay, PayPal — all payments are 256-bit SSL encrypted for your peace of mind.',
      bgColor: Color(0xFF00081A),
      accentColor: Color(0xFF3498DB),
    ),
    const _OnboardPage(
      emoji: '🌍',
      tag: 'MULTILINGUAL',
      title: 'English &\nArabic Support',
      subtitle:
          'Full Arabic language support for our clients in Saudi Arabia, UAE, and the wider Middle East.',
      bgColor: Color(0xFF1A000D),
      accentColor: Color(0xFFE74C3C),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => AuthScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Page content
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _buildPage(_pages[i]),
          ),

          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 20,
            child: GestureDetector(
              onTap: _finish,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceHighest),
                ),
                child: Text(
                  'Skip',
                  style: GoogleFonts.raleway(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),

          // Bottom nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  24, 20, 24, MediaQuery.of(context).padding.bottom + 24),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border:
                    Border(top: BorderSide(color: AppColors.surfaceHighest)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppColors.gold,
                      dotColor: AppColors.surfaceHighest,
                      dotHeight: 6,
                      dotWidth: 6,
                      expansionFactor: 3,
                    ),
                  ),
                  GoldButton(
                    label: _page == _pages.length - 1 ? 'Get Started' : 'Next',
                    width: 130,
                    height: 48,
                    icon: _page == _pages.length - 1
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                    onTap: _next,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardPage page) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [page.bgColor, AppColors.background],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.6],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 60, 32, 160),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Big emoji
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: page.accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: page.accentColor.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(page.emoji, style: const TextStyle(fontSize: 52)),
                ),
              )
                  .animate()
                  .scale(duration: 500.ms, curve: Curves.elasticOut)
                  .fadeIn(),

              const SizedBox(height: 32),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: page.accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: page.accentColor.withValues(alpha: 0.25)),
                ),
                child: Text(
                  page.tag,
                  style: GoogleFonts.raleway(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: page.accentColor,
                    letterSpacing: 2,
                  ),
                ),
              )
                  .animate(delay: 100.ms)
                  .fadeIn()
                  .slideX(begin: -0.2, curve: Curves.easeOut),

              const SizedBox(height: 16),

              Text(
                page.title,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
              )
                  .animate(delay: 150.ms)
                  .fadeIn()
                  .slideY(begin: 0.2, curve: Curves.easeOut),

              const SizedBox(height: 16),

              Text(
                page.subtitle,
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.65,
                ),
              ).animate(delay: 250.ms).fadeIn(),

              const Spacer(),

              // Feature dots
              Row(
                children: List.generate(
                  3,
                  (i) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: page.accentColor.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ).animate(delay: 350.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardPage {
  final String emoji;
  final String tag;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color accentColor;

  const _OnboardPage({
    required this.emoji,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.accentColor,
  });
}
