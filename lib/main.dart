import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/auth_provider.dart';
import 'app/router.dart'; // createRouter
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.checkAuthStatus();

  final router = createRouter(authProvider); // ✅ Передаём уже проверенный провайдер

  runApp(
    ChangeNotifierProvider<AuthProvider>.value(
      value: authProvider,
      child: MyApp(router: router),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'LangApp',
    );
  }
}
