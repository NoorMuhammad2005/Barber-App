// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotateCtrl;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();

    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // Navigate after intro
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => AuthScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Radial background rings
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _SplashPainter(_pulseCtrl),
                ),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Rotating logo
                AnimatedBuilder(
                  animation: _rotateCtrl,
                  builder: (_, child) => Transform.rotate(
                    angle: _rotateCtrl.value * 2 * 3.14159,
                    child: child,
                  ),
                  child: AnimatedBuilder(
                    animation: _pulseCtrl,
                    builder: (_, child) => Container(
                      width: 110 + _pulseCtrl.value * 6,
                      height: 110 + _pulseCtrl.value * 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.goldGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold
                                .withOpacity(0.2 + _pulseCtrl.value * 0.3),
                            blurRadius: 40 + _pulseCtrl.value * 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('✂️', style: TextStyle(fontSize: 52)),
                      ),
                    ),
                  ),
                ).animate().scale(
                      duration: 700.ms,
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 32),

                Text(
                  'NOIR BARBER',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: 8,
                  ),
                )
                    .animate(delay: 300.ms)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, curve: Curves.easeOut),

                const SizedBox(height: 10),

                Text(
                  'WHERE ART MEETS LUXURY',
                  style: GoogleFonts.raleway(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                    letterSpacing: 4,
                  ),
                ).animate(delay: 500.ms).fadeIn(duration: 600.ms),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _locationDot('London'),
                    _sep(),
                    _locationDot('Riyadh'),
                    _sep(),
                    _locationDot('Dubai'),
                  ],
                ).animate(delay: 700.ms).fadeIn(duration: 600.ms),
              ],
            ),
          ),

          // Bottom loading bar
          Positioned(
            bottom: 60,
            left: 60,
            right: 60,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.surfaceHighest,
                    valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                    minHeight: 3,
                  ),
                ).animate(delay: 800.ms).fadeIn(),
                const SizedBox(height: 12),
                Text(
                  'PREMIUM BARBER EXPERIENCE',
                  style: GoogleFonts.raleway(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                    letterSpacing: 3,
                  ),
                ).animate(delay: 900.ms).fadeIn(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationDot(String city) => Row(
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppColors.gold,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            city,
            style: GoogleFonts.raleway(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textGold,
            ),
          ),
        ],
      );

  Widget _sep() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          '·',
          style: GoogleFonts.raleway(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
      );
}

class _SplashPainter extends CustomPainter {
  final Animation<double> animation;
  _SplashPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withOpacity(0.04 + animation.value * 0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.longestSide * 0.7;

    for (double r = 60; r < maxR; r += 60) {
      canvas.drawCircle(center, r + animation.value * 8, paint);
    }

    // Diagonal cross lines
    final linePaint = Paint()
      ..color = AppColors.gold.withOpacity(0.03)
      ..strokeWidth = 0.5;
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), linePaint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), linePaint);
  }

  @override
  bool shouldRepaint(covariant _SplashPainter oldDelegate) {
    return oldDelegate.animation.value != animation.value;
  }
}
