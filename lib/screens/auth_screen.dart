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
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with TickerProviderStateMixin {
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildHeroSection(),
          
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildToggle(),
          
                    const SizedBox(height: 28),
          
                    if (!_isLogin) _buildNameField(),
          
                    _buildEmailField(),
                    const SizedBox(height: 16),
          
                    _buildPasswordField(),
          
                    if (_isLogin) _buildForgotPassword(),
          
                    const SizedBox(height: 28),
          
                    GoldButton(
                      label: _isLogin
                          ? ('Sign In')
                          : ('Sign Up'),
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
                    _guestBtn(),
          
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= AUTH LOGIC =================
Future<void> _handleAuth() async {
  if (!_formKey.currentState!.validate()) {
  return;
}
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
  } 
  catch (e, stackTrace) {
  print("AUTH ERROR: $e");
  print(stackTrace);

  String message = e.toString();

  if (message.contains("Invalid login credentials")) {
    message = "Incorrect email or password.";
  } else if (message.contains("User already registered")) {
    message = "This email is already registered.";
  } else if (message.contains("Email not confirmed")) {
    message = "Please verify your email first.";
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
finally {
  if (mounted) {
    setState(() => _isLoading = false);
  }
}
}


void _navigateToMain() {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => const MainShell(),
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 600),
    ),
  );
}


  

  // ================= UI WIDGETS =================

  Widget _buildToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _toggleBtn('Sign In', _isLogin, 
              () => setState(() => _isLogin = true)),
          _toggleBtn('Sign Up', !_isLogin,
              () => setState(() => _isLogin = false)),
        ],
      ),
    );
  }

 Widget _buildNameField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Full Name'),
      const SizedBox(height: 8),

      TextFormField(
        controller: _nameCtrl,
        decoration: const InputDecoration(
          hintText: 'Enter Full Name',
        ),
        validator: (value) {
          if (!_isLogin && (value == null || value.trim().isEmpty)) {
            return "Please enter your full name";
          }
          return null;
        },
      ),

      const SizedBox(height: 16),
    ],
  );
}
 Widget _buildEmailField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Email'),
      const SizedBox(height: 8),

      TextFormField(
        controller: _emailCtrl,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: 'Enter Email',
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please enter your email";
          }

          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return "Enter a valid email";
          }

          return null;
        },
      ),
    ],
  );
}

  // Widget _buildPasswordField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('Password'),
  //       const SizedBox(height: 8),
  //       TextField(controller: _passCtrl, obscureText: true),
  //     ],
  //   );
  // }
  Widget _buildPasswordField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Password',
        style: GoogleFonts.raleway(
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),

     TextFormField(
  controller: _passCtrl,
  obscureText: _obscurePassword,
  decoration: InputDecoration(
    hintText: 'Enter Password',
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePassword
            ? Icons.visibility_off_rounded
            : Icons.visibility_rounded,
      ),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
    ),
  ),

  validator: (value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  },
),
    ],
  );
}

  Widget _buildForgotPassword() {
  return Align(
    alignment: Alignment.centerRight,
    child: TextButton(
      onPressed: () {
        // Forgot Password Screen
      },
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          color: AppColors.gold,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

  Widget _guestBtn() {
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
          child: Text('Continue as Guest'),
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
          child: Center(
            child: Text(
  label,
  style: GoogleFonts.raleway(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: active
        ? Colors.black
        : AppColors.textSecondary,
  ),
),
            ),
        ),
      ),
    );
  }

//   Widget _buildHeroSection() {
//   return SizedBox(
//     height: 300,
//     width: double.infinity,
//     child: Stack(
//       fit: StackFit.expand,
//       children: [
//         // Background Image
//         Image.asset(
//           'assets/login_banner.png',
//           fit: BoxFit.cover,
//         )
//             .animate(
//               onPlay: (controller) =>
//                   controller.repeat(reverse: true),
//             )
//             .scale(
//               begin: const Offset(1, 1),
//               end: const Offset(1.05, 1.05),
//               duration: const Duration(seconds: 8),
//             ),

//         // Dark Overlay
//         Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.black38,
//                 Colors.black54,
//                 Colors.black87,
//                 AppColors.background,
//               ],
//             ),
//           ),
//         ),

//         // Text
//         Positioned(
//           left: 24,
//           right: 24,
//           bottom: 30,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'NOIR BARBER',
//                 style: GoogleFonts.cormorantGaramond(
//                   fontSize: 36,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   letterSpacing: 3,
//                 ),
//               ),

//               const SizedBox(height: 8),

//               Text(
//                 'Premium Grooming Experience',
//                 style: GoogleFonts.raleway(
//                   fontSize: 15,
//                   color: Colors.white70,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget _buildHeroSection() {
  return SizedBox(
    height: 220,
    width: double.infinity,
    child: Stack(
      fit: StackFit.expand,
      children: [

        // Background Image
        Image.asset(
          "assets/login_banner.png",
          fit: BoxFit.cover,
        )
            .animate(
              onPlay: (c) => c.repeat(reverse: true),
            )
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.06, 1.06),
              duration: const Duration(seconds: 10),
            ),

        // Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(.15),
                Colors.black.withOpacity(.45),
                Colors.black.withOpacity(.78),
                AppColors.background,
              ],
            ),
          ),
        ),

        // Gold Glow Right
        Positioned(
          right: -80,
          top: -30,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold.withOpacity(.10),
            ),
          ),
        ),

        // Gold Glow Left
        Positioned(
          left: -70,
          bottom: -40,
          child: Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold.withOpacity(.06),
            ),
          ),
        ),

        // Floating Gold Dot
        Positioned(
          top: 45,
          left: 30,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.gold,
              shape: BoxShape.circle,
            ),
          )
              .animate(
                onPlay: (c) => c.repeat(reverse: true),
              )
              .moveY(
                begin: -8,
                end: 8,
                duration: const Duration(seconds: 3),
              ),
        ),

        // Floating White Dot
        Positioned(
          top: 80,
          right: 45,
          child: Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.8),
              shape: BoxShape.circle,
            ),
          )
              .animate(
                onPlay: (c) => c.repeat(reverse: true),
              )
              .moveY(
                begin: 8,
                end: -8,
                duration: const Duration(seconds: 4),
              ),
        ),

        // Bottom Content
        Positioned(
          left: 24,
          right: 24,
          bottom: 25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.08),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppColors.gold.withOpacity(.45),
                  ),
                ),
                child: Text(
                  "PREMIUM BARBERSHOP",
                  style: GoogleFonts.raleway(
                    color: AppColors.gold,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -.2),

              const SizedBox(height: 12),

              // Gold Line
              Container(
                width: 55,
                height: 3,
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
              )
                  .animate()
                  .fadeIn(delay: 300.ms),

              const SizedBox(height: 12),

              // Title
              Text(
                "NOIR BARBER",
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                  shadows: const [
                    Shadow(
                      blurRadius: 20,
                      color: Colors.black54,
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 500.ms)
                  .slideY(begin: .3),

              const SizedBox(height: 6),

              // Subtitle
              Text(
                "Luxury Haircuts • Beard Styling • Premium Grooming",
                style: GoogleFonts.raleway(
                  fontSize: 13,
                  color: Colors.white70,
                  height: 1.4,
                ),
              )
                  .animate()
                  .fadeIn(delay: 700.ms),

              const SizedBox(height: 14),

              // Rating
              Row(
                children: [

                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.gold,
                    size: 18,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    "4.9",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.white54,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    "10K+ Happy Clients",
                    style: GoogleFonts.raleway(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 900.ms),
            ],
          ),
        ),
      ],
    ),
  );
}
    }