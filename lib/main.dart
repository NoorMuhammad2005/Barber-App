// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'utils/app_theme.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Notifications
  await NotificationService.init();

  // Supabase – replace with real keys via --dart-define
  await Supabase.initialize(
      url: "https://tkesddbndmfbwbsdveff.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRrZXNkZGJuZG1mYndic2R2ZWZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg5MzMxOTksImV4cCI6MjA5NDUwOTE5OX0.EWzwM7R1FB5-M_rZnQBR58CCoK3OutDC3VATCUBP7Tw",
      debug: false);

  // await Supabase.initialize(
  //   url: const String.fromEnvironment(
  //     'SUPABASE_URL',
  //     defaultValue: 'https://your-project.supabase.co',
  //   ),
  //   anonKey: const String.fromEnvironment(
  //     'SUPABASE_ANON_KEY',
  //     defaultValue: 'your-anon-key',
  //   ),
  //   debug: false,
  // );

  runApp(const ProviderScope(child: NoirBarberApp()));
}

class NoirBarberApp extends ConsumerWidget {
  const NoirBarberApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Noir Barber',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // Entry point: Splash → Onboarding (first time) → Auth → App
      home: const SplashScreen(),
    );
  }
}
