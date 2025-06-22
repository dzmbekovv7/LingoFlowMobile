// lib/features/profile/presentation/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:lingoo/core/services/auth_provider.dart';
import 'package:lingoo/shared/widgets/protected_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // ✅ NEW

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = '';
  String name = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final decodedToken = JwtDecoder.decode(token);
      setState(() {
        email = decodedToken['email'] ?? 'Unknown';
        name = decodedToken['name'] ?? 'Unknown';
      });
    } else {
      setState(() {
        email = 'Not logged in';
      });
    }
  }

  void logout() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.logout();
    if (mounted) context.go('/register');
  }
  @override
  Widget build(BuildContext context) {
    return ProtectedPage(
      currentIndex: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/men/75.jpg',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              email,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: logout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            )
          ],
        ),
      ),
    );
  }
}
