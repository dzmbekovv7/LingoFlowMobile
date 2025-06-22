import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/auth/presentation/confirm_screen.dart';

final router = GoRouter(
  initialLocation: '/register',
  routes: [
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/confirm', builder: (_, __) => const ConfirmScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
  ],
);
