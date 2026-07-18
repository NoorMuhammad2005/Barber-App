// lib/utils/app_router.dart
import 'package:barbershop_app/screens/app_start.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/main_shell.dart';
import '../screens/home_screen.dart';
import '../screens/services_screen.dart';
import '../screens/booking_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/barbers_screen.dart';
import '../screens/barber_detail_screen.dart';
import '../screens/reviews_screen.dart';
import '../screens/location_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/search_screen.dart';
import '../screens/loyalty_screen.dart';
import '../screens/admin_screen.dart';
import '../models/models.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      // ── Splash ─────────────────────────────────────────────────────────────
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (_, __) => const AppStartup(),
      ),

      // ── Onboarding ─────────────────────────────────────────────────────────
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),

      // ── Auth ───────────────────────────────────────────────────────────────
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (_, __) => AuthScreen(),
      ),

      // ── Main Shell (bottom nav) ────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) {
          return const MainShell();
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: '/services',
            name: 'services',
            builder: (_, __) => const ServicesScreen(),
          ),
          GoRoute(
            path: '/booking',
            name: 'booking',
            builder: (_, __) => const BookingScreen(),
          ),
          GoRoute(
            path: '/location',
            name: 'location',
            builder: (_, __) => const LocationScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
      ),

      // ── Standalone screens (pushed over shell) ─────────────────────────────
      GoRoute(
        path: '/barbers',
        name: 'barbers',
        builder: (_, __) => const BarbersScreen(),
      ),
      GoRoute(
        path: '/reviews',
        name: 'reviews',
        builder: (_, __) => const ReviewsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (_, __) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (_, __) => const SearchScreen(),
      ),
      GoRoute(
        path: '/loyalty',
        name: 'loyalty',
        builder: (_, __) => const LoyaltyScreen(),
      ),
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (_, __) => const AdminScreen(),
      ),
    ],

    // Custom page transitions
    observers: [_RouteObserver()],

    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text(
              'Page not found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text(
                'Go Home',
                style: TextStyle(color: Color(0xFFD4AF37)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
});

class _RouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint('Navigated to: ${route.settings.name}');
  }
}
