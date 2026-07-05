// lib/screens/auth_screen.dart
import 'package:barbershop_app/providers/auth_provider.dart';
import 'package:barbershop_app/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
            _buildHeroSection(isArabic),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildToggle(isArabic),

                  const SizedBox(height: 28),

                  if (!_isLogin) _buildNameField(isArabic),

                  _buildEmailField(isArabic),
                  const SizedBox(height: 16),

                  _buildPasswordField(isArabic),

                  if (_isLogin) _buildForgotPassword(isArabic),

                  const SizedBox(height: 28),

                  GoldButton(
                    label: _isLogin
                        ? (isArabic ? 'دخول' : 'Sign In')
                        : (isArabic ? 'إنشاء الحساب' : 'Sign Up'),
                    isLoading: _isLoading,
                    icon: _isLogin
                        ? Icons.login_rounded
                        : Icons.person_add_rounded,
                    onTap: _handleAuth,
                  ),

                  const SizedBox(height: 20),
                  const GoldDivider(),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _socialBtn('🍎', 'Apple'),
                      const SizedBox(width: 12),
                      _socialBtn('🔵', 'Google'),
                    ],
                  ),

                  const SizedBox(height: 24),
                  _guestBtn(isArabic),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= AUTH LOGIC =================
Future<void> _handleAuth() async {
  setState(() => _isLoading = true);

  try {
    final authService = ref.read(authServiceProvider);

    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();
    final name = _nameCtrl.text.trim();

    if (_isLogin) {
      // LOGIN
      final res = await authService.login(email, password);

      print("========== LOGIN ==========");
      print("User: ${res.user}");
      print("Session: ${res.session}");

      if (res.user != null) {
        print("Before loadProfile");

        await ref
            .read(profileProvider.notifier)
            .loadProfile(res.user!.id);

        print("After loadProfile");

        _navigateToMain();
      } else {
        print("Login Failed - User is null");
      }
    } else {
      // SIGNUP
      final res = await authService.signup(email, password, name);

      print("========== SIGNUP ==========");
      print("User: ${res.user}");
      print("Session: ${res.session}");

      if (res.user != null) {
        print("Before loadProfile");

        await ref
            .read(profileProvider.notifier)
            .loadProfile(res.user!.id);

        print("After loadProfile");

        _navigateToMain();
      } else {
        print("Signup Failed - User is null");
      }
    }
  } catch (e, stackTrace) {
    print("AUTH ERROR: $e");
    print(stackTrace);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

void _navigateToMain() {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => MainShell(),
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 600),
    ),
  );
}


  // Future<void> _handleAuth() async {
  //   setState(() => _isLoading = true);

  //   try {
  //     final authService = ref.read(authServiceProvider);

  //     final email = _emailCtrl.text.trim();
  //     final password = _passCtrl.text.trim();
  //     final name = _nameCtrl.text.trim();

  //     if (_isLogin) {
  //       final res = await authService.login(email, password);

  //       if (res.user != null) {
  //         await ref
  //             .read(profileProvider.notifier)
  //             .loadProfile(res.user!.id);

  //         _navigateToMain();
  //       }
  //     } else {
  //       final res = await authService.signup(email, password, name);

  //       if (res.user != null) {
  //         await ref
  //             .read(profileProvider.notifier)
  //             .loadProfile(res.user!.id);

  //         _navigateToMain();
  //       }
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(e.toString())));
  //   }

  //   setState(() => _isLoading = false);
  // }

  // void _navigateToMain() {
  //   Navigator.of(context).pushReplacement(
  //     PageRouteBuilder(
  //       pageBuilder: (_, __, ___) => MainShell(),
  //       transitionsBuilder: (_, animation, __, child) =>
  //           FadeTransition(opacity: animation, child: child),
  //       transitionDuration: const Duration(milliseconds: 600),
  //     ),
  //   );
  // }

  // ================= UI WIDGETS =================

  Widget _buildToggle(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _toggleBtn(isArabic ? 'تسجيل الدخول' : 'Sign In', _isLogin,
              () => setState(() => _isLogin = true)),
          _toggleBtn(isArabic ? 'إنشاء حساب' : 'Sign Up', !_isLogin,
              () => setState(() => _isLogin = false)),
        ],
      ),
    );
  }

  Widget _buildNameField(bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isArabic ? 'الاسم الكامل' : 'Full Name'),
        const SizedBox(height: 8),
        TextField(controller: _nameCtrl),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEmailField(bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isArabic ? 'البريد الإلكتروني' : 'Email'),
        const SizedBox(height: 8),
        TextField(controller: _emailCtrl),
      ],
    );
  }

  Widget _buildPasswordField(bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isArabic ? 'كلمة المرور' : 'Password'),
        const SizedBox(height: 8),
        TextField(controller: _passCtrl, obscureText: true),
      ],
    );
  }

  Widget _buildForgotPassword(bool isArabic) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(isArabic ? 'نسيت كلمة المرور؟' : 'Forgot password?'),
    );
  }

  Widget _guestBtn(bool isArabic) {
    return GestureDetector(
      onTap: _navigateToMain,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.surfaceHighest),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(isArabic ? 'متابعة كضيف' : 'Continue as Guest'),
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
        ),
        child: Center(child: Text('$emoji $label')),
      ),
    );
  }

  Widget _toggleBtn(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.amber : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(label)),
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isArabic) {
    return Container(
      height: 250,
      width: double.infinity,
      color: Colors.black,
      child: Center(child: Text("NOIR BARBER")),
    );
  }
}