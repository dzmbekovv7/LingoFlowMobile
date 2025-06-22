// lib/shared/widgets/protected_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lingoo/core/services/auth_provider.dart';
import 'authenticated_scaffold.dart';

class ProtectedPage extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const ProtectedPage({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return AuthenticatedScaffold(
      currentIndex: currentIndex,
      onTap: (index) {
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
      body: child,
    );
  }
}
