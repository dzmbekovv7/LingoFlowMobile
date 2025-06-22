// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ ADD THIS
import 'core/services/auth_provider.dart'; // ✅ Your AuthProvider
import 'app/router.dart'; // ✅ GoRouter config

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider()..checkAuthStatus(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'LangApp',
    );
  }
}
