// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/app_theme.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';
import 'main_shell.dart';

class AuthScreen extends ConsumerStatefulWidget {
  AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with TickerProviderStateMixin {
  bool _isLogin = true;
  bool _isLoading = false;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  late AnimationController _logoController;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(languageProvider) == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Hero top
            _buildHeroSection(isArabic),

            // Form
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.surfaceHighest),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        _toggleBtn(
                          isArabic ? 'تسجيل الدخول' : 'Sign In',
                          _isLogin,
                          () => setState(() => _isLogin = true),
                        ),
                        _toggleBtn(
                          isArabic ? 'إنشاء حساب' : 'Sign Up',
                          !_isLogin,
                          () => setState(() => _isLogin = false),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  if (!_isLogin) ...[
                    Text(
                      isArabic ? 'الاسم الكامل' : 'Full Name',
                      style: GoogleFonts.raleway(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameCtrl,
                      style: GoogleFonts.raleway(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: isArabic ? 'أدخل اسمك' : 'Enter your name',
                        prefixIcon: const Icon(Icons.person_outline_rounded,
                            color: AppColors.textMuted, size: 20),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  Text(
                    isArabic ? 'البريد الإلكتروني' : 'Email Address',
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailCtrl,
                    style: GoogleFonts.raleway(color: AppColors.textPrimary),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText:
                          isArabic ? 'you@example.com' : 'you@example.com',
                      prefixIcon: const Icon(Icons.mail_outline_rounded,
                          color: AppColors.textMuted, size: 20),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    isArabic ? 'كلمة المرور' : 'Password',
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passCtrl,
                    obscureText: true,
                    style: GoogleFonts.raleway(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline_rounded,
                          color: AppColors.textMuted, size: 20),
                      suffixIcon: const Icon(Icons.visibility_off_outlined,
                          color: AppColors.textMuted, size: 18),
                    ),
                  ),

                  if (_isLogin) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        isArabic ? 'نسيت كلمة المرور؟' : 'Forgot password?',
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  GoldButton(
                    label: _isLogin
                        ? (isArabic ? 'دخول' : 'Sign In')
                        : (isArabic ? 'إنشاء الحساب' : 'Create Account'),
                    isLoading: _isLoading,
                    icon: _isLogin
                        ? Icons.login_rounded
                        : Icons.person_add_rounded,
                    onTap: _handleAuth,
                  ),

                  const SizedBox(height: 20),

                  const GoldDivider(),

                  const SizedBox(height: 20),

                  // Social auth buttons
                  Row(
                    children: [
                      _socialBtn('🍎', 'Apple'),
                      const SizedBox(width: 12),
                      _socialBtn('🔵', 'Google'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Continue as guest
                  GestureDetector(
                    onTap: _navigateToMain,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.surfaceHighest),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          isArabic ? 'متابعة كضيف' : 'Continue as Guest',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isArabic) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1500), Color(0xFF0D0B00), Color(0xFF141414)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(painter: _RadialPatternPainter()),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_logoController)
                    ..drive(CurveTween(curve: Curves.linear)),
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.goldGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('✂️', style: TextStyle(fontSize: 44)),
                    ),
                  ),
                ).animate().scale(
                      duration: 800.ms,
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 20),

                Text(
                  'NOIR BARBER',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: 6,
                  ),
                ).animate(delay: 200.ms).fadeIn(),

                const SizedBox(height: 8),

                Text(
                  isArabic
                      ? 'حيث الفن يلتقي بالفخامة'
                      : 'WHERE ART MEETS LUXURY',
                  style: GoogleFonts.raleway(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                    letterSpacing: 3,
                  ),
                ).animate(delay: 300.ms).fadeIn(),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dot(),
                    const SizedBox(width: 8),
                    Text(
                      isArabic
                          ? 'لندن • الرياض • دبي'
                          : 'London • Riyadh • Dubai',
                      style: GoogleFonts.raleway(
                        fontSize: 13,
                        color: AppColors.textGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _dot(),
                  ],
                ).animate(delay: 400.ms).fadeIn(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot() => Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(
          color: AppColors.gold,
          shape: BoxShape.circle,
        ),
      );

  Widget _toggleBtn(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.goldGradient : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isActive ? AppColors.background : AppColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialBtn(String emoji, String label) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceHighest),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAuth() async {
    setState(() => _isLoading = true);

    try {
      final email = _emailCtrl.text.trim();
      final password = _passCtrl.text.trim();
      final name = _nameCtrl.text.trim();

      if (email.isEmpty || password.isEmpty) {
        throw Exception("Email and password required");
      }
      final supabase = Supabase.instance.client;
      if (_isLogin) {
        // 🔑 LOGIN
        final res = await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );

        if (res.user != null) {
          _navigateToMain();
        }
      } else {
        // 🆕 SIGNUP
        final res = await supabase.auth.signUp(
          email: email,
          password: password,
          data: {
            'name': name,
          },
        );

        if (res.user != null) {
          _navigateToMain();
        }
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => _isLoading = false);
  }
  // Future<void> _handleAuth() async {
  //   setState(() => _isLoading = true);
  //   await Future.delayed(const Duration(seconds: 1));
  //   setState(() => _isLoading = false);
  //   _navigateToMain();
  // }

  void _navigateToMain() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => MainShell(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }
}

class _RadialPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final center = Offset(size.width / 2, size.height / 2);
    for (double r = 30; r < size.width; r += 40) {
      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
