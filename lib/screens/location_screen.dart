// lib/screens/location_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_theme.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';

class LocationScreen extends ConsumerWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(languageProvider) == 'ar';

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
          isArabic ? 'الموقع والتواصل' : 'Location & Contact',
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
            // Map Placeholder
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.surfaceHighest),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  // Simulated map
                  CustomPaint(
                    size: const Size(double.infinity, 220),
                    painter: _MapPainter(),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: AppColors.goldGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withOpacity(0.4),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.background,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.background.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isArabic ? 'نوار باربر • لندن' : 'Noir Barber • London',
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () async {
                        final url = Uri.parse(
                            'https://maps.google.com/?q=Mayfair,London');
                        if (await canLaunchUrl(url)) launchUrl(url);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isArabic ? 'الاتجاهات' : 'Directions',
                          style: GoogleFonts.raleway(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.background,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.1),

            const SizedBox(height: 24),

            // Address Info
            _infoCard(
              icon: Icons.location_on_rounded,
              title: isArabic ? 'العنوان' : 'Address',
              content: isArabic
                  ? '42 شارع ماي فير، لندن W1K 4HX\nالمملكة المتحدة'
                  : '42 Mayfair Street, London W1K 4HX\nUnited Kingdom',
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: 12),

            _infoCard(
              icon: Icons.access_time_rounded,
              title: isArabic ? 'أوقات العمل' : 'Opening Hours',
              content: isArabic
                  ? 'الإثنين - الجمعة: 9ص - 8م\nالسبت: 9ص - 6م\nالأحد: مغلق'
                  : 'Mon - Fri: 9:00 AM - 8:00 PM\nSat: 9:00 AM - 6:00 PM\nSun: Closed',
            ).animate(delay: 150.ms).fadeIn(),

            const SizedBox(height: 24),

            Text(
              isArabic ? 'تواصل معنا' : 'Get in Touch',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 16),

            // Contact Buttons
            _contactButton(
              icon: Icons.phone_rounded,
              label: isArabic ? 'اتصل بنا' : 'Call Us',
              subtitle: '+44 20 7946 0958',
              color: AppColors.success,
              onTap: () async {
                final url = Uri.parse('tel:+442079460958');
                if (await canLaunchUrl(url)) launchUrl(url);
              },
            ).animate(delay: 250.ms).fadeIn().slideX(begin: -0.1),

            const SizedBox(height: 12),

            _contactButton(
              icon: Icons.chat_rounded,
              label: 'WhatsApp',
              subtitle: isArabic ? 'تواصل عبر واتساب' : 'Message on WhatsApp',
              color: const Color(0xFF25D366),
              onTap: () async {
                final url = Uri.parse('https://wa.me/442079460958');
                if (await canLaunchUrl(url)) launchUrl(url);
              },
            ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.1),

            const SizedBox(height: 12),

            _contactButton(
              icon: Icons.mail_rounded,
              label: isArabic ? 'البريد الإلكتروني' : 'Email Us',
              subtitle: 'hello@noirbarber.co.uk',
              color: AppColors.info,
              onTap: () async {
                final url = Uri.parse('mailto:hello@noirbarber.co.uk');
                if (await canLaunchUrl(url)) launchUrl(url);
              },
            ).animate(delay: 350.ms).fadeIn().slideX(begin: -0.1),

            const SizedBox(height: 12),

            _contactButton(
              icon: Icons.camera_alt_rounded,
              label: 'Instagram',
              subtitle: '@noirbarber',
              color: const Color(0xFFE1306C),
              onTap: () async {
                final url = Uri.parse('https://instagram.com/noirbarber');
                if (await canLaunchUrl(url)) launchUrl(url);
              },
            ).animate(delay: 400.ms).fadeIn().slideX(begin: -0.1),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceHighest),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.goldGlow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.gold, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.raleway(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.raleway(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: color, size: 16),
          ],
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF1A1F2E);
    canvas.drawRect(Offset.zero & size, bg);

    final roadPaint = Paint()
      ..color = const Color(0xFF2A3040)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final roads = [
      [Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.3)],
      [Offset(0, size.height * 0.6), Offset(size.width, size.height * 0.6)],
      [Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height)],
      [Offset(size.width * 0.7, 0), Offset(size.width * 0.7, size.height)],
    ];

    for (final road in roads) {
      canvas.drawLine(road[0], road[1], roadPaint);
    }

    final blockPaint = Paint()..color = const Color(0xFF222836);
    final blocks = [
      Rect.fromLTWH(10, 10, size.width * 0.25, size.height * 0.25),
      Rect.fromLTWH(size.width * 0.35, 10, size.width * 0.3, size.height * 0.25),
      Rect.fromLTWH(10, size.height * 0.35, size.width * 0.25, size.height * 0.2),
    ];

    for (final block in blocks) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(block, const Radius.circular(4)), blockPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
