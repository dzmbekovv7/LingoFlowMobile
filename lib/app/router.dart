import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/confirm_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/vocab/presentation/vocab_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../core/services/auth_provider.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/auth/presentation/userInfo_screen.dart';

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(AuthProvider authProvider) {
    authProvider.addListener(notifyListeners);
  }
}

GoRouter createRouter(AuthProvider authProvider) {
  final initialLocation = authProvider.isLoggedIn ? '/home' : '/register';
  final userId = authProvider.userId;
  final token = authProvider.token;

  return GoRouter(
    initialLocation: initialLocation,
    refreshListenable: GoRouterRefreshNotifier(authProvider),
    routes: [
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/confirm', builder: (_, __) => const ConfirmScreen()),
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
      GoRoute(
        path: '/vocab',
        builder: (context, state) {
          return const VocabScreen();
        },
      ),


      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(
        path: '/userInfo',
        builder: (_, __) {
          if (userId == null || token == null) {
            return const Scaffold(
              body: Center(child: Text('User not logged in')),
            );
          }
          return UserInfoScreen(userId: userId, token: token);
        },
      ),
    ],
  );
}
