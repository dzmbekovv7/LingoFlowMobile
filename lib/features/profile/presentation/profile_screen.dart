import 'package:flutter/material.dart';
import 'package:lingoo/core/services/auth_provider.dart';
import 'package:lingoo/shared/widgets/protected_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dio/dio.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = '';
  String name = '';
  String nativeLanguage = 'Не указан';
  List<String> targetLanguages = [];
  int dayStreak = 0;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final decoded = JwtDecoder.decode(token);
      final userId = decoded['sub'];

      try {
        final res = await Dio().get('http://192.168.56.1:3333/users/profile/$userId',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        final user = res.data;

        setState(() {
          email = user['email'] ?? 'Unknown';
          name = user['name'] ?? 'Unknown';
          nativeLanguage = user['nativeLanguage'] ?? 'Не указан';
          targetLanguages = List<String>.from(user['targetLanguage'] ?? []);
          // если нужно отобразить: level, goals, interests
          // level = user['level'] ?? 'Не указан';
          // goals = user['goals'] ?? '';
          // interests = List<String>.from(user['interests'] ?? []);
        });
      } catch (e) {
        print('Ошибка получения профиля: $e');
      }
    }
  }


  void logout() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.logout();
    if (mounted) context.go('/register');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final purpleGradient = LinearGradient(
      colors: [Colors.deepPurple.shade800, Colors.purple.shade400],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return ProtectedPage(
      currentIndex: 2,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Полукруглый фиолетовый верх
            Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: purpleGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(90),
                  bottomRight: Radius.circular(90),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: -50,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: const NetworkImage(
                        'https://randomuser.me/api/portraits/men/75.jpg',
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.whatshot, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              'Day Streak: $dayStreak',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(Icons.location_on, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              'Япония',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Переход к настройкам
                          },
                          icon: const Icon(Icons.settings, color: Colors.white),
                          label: const Text(
                            'Настройки',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12), // отступ между кнопками
                        ElevatedButton.icon(
                          onPressed: () {
                            // logout action
                            final auth = Provider.of<AuthProvider>(context, listen: false);
                            auth.logout();
                            if (mounted) context.go('/register');
                          },
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 70), // чтобы аватарка не перекрывалась

            // Родной язык
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const Icon(Icons.language, color: Colors.deepPurple),
                  const SizedBox(width: 8),
                  Text(
                    'Родной язык: ',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(nativeLanguage, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Пригласи друзей с фиолетовым фоном
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Пригласи друзей в LanguaFlow',
                  style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)
                  ,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Белый блок Learning + языки
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Learning',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: targetLanguages.isEmpty
                        ? [
                      const Chip(
                        label: Text('Языки не указаны'),
                        backgroundColor: Colors.deepPurpleAccent,
                        labelStyle: TextStyle(color: Colors.white),
                      )
                    ]
                        : targetLanguages
                        .map((lang) => Chip(
                      label: Text(lang),
                      backgroundColor: Colors.deepPurple.shade200,
                      labelStyle: const TextStyle(color: Colors.white),
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
