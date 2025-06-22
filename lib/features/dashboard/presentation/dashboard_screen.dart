// features/dashboard/presentation/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:lingoo/shared/widgets/authenticated_scaffold.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthenticatedScaffold(
      currentIndex: 0,
      onTap: (index) {
        // Navigate with GoRouter based on index
        switch (index) {
          case 0:
            context.go('/dashboard');
            break;
          case 1:
            context.go('/vocab');
            break;
          case 2:
            context.go('/profile');
            break;
        }
      },
      body: const Center(child: Text('Dashboard')),
    );
  }
}
