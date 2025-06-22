// shared/widgets/authenticated_scaffold.dart
import 'package:flutter/material.dart';

class AuthenticatedScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final void Function(int)? onTap;

  const AuthenticatedScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.white,           // светлый фон
        selectedItemColor: Colors.blue,          // цвет выбранного
        unselectedItemColor: Colors.grey,        // цвет невыбранных
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Vocab'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),

    );
  }
}
