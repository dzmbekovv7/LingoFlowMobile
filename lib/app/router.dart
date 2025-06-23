// app/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // ✅ Needed
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/confirm_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/vocab/presentation/vocab_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../core/services/auth_provider.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/auth/presentation/userInfo_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // ✅ NEW
class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(AuthProvider authProvider) {
    authProvider.addListener(notifyListeners);
  }
}

final router = GoRouter(
  initialLocation: '/register',
  // Переинициализацию authProvider вынести наружу и передавать сюда:
  refreshListenable: GoRouterRefreshNotifier(AuthProvider()),

  routes: [
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/confirm', builder: (context, state) => const ConfirmScreen()),

    GoRoute(
      path: '/userInfo',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        final userId = extra?['userId'] as String?;
        final token = extra?['token'] as String?;

        if (userId == null || token == null) {
          return const Scaffold(
            body: Center(child: Text('User ID or token missing')),
          );
        }

        return UserInfoScreen(userId: userId, token: token);
      },
    ),


    GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
    GoRoute(path: '/vocab', builder: (context, state) => const VocabScreen()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
  ],
);
