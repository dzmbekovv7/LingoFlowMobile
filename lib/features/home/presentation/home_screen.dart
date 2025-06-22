import 'package:flutter/material.dart';
import '../../../shared/widgets/protected_page.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProtectedPage(
      currentIndex: 0,

      child: const Center(

        child: Text(
          '🎉 CONGRATULATIONS!\nYour account is confirmed!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
