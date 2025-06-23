import 'package:flutter/material.dart';
import 'package:lingoo/shared/widgets/protected_page.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});  // убрал const

  @override
  Widget build(BuildContext context) {
    final playlists = ['Начальный уровень', 'Средний уровень', 'Продвинутый уровень'];
    final videos = [
      {
        'title': 'Урок 1: Приветствия',
        'thumbnail': 'https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg',
        'duration': '10:23',
      },
      {
        'title': 'Урок 2: Основы грамматики',
        'thumbnail': 'https://img.youtube.com/vi/3JZ_D3ELwOQ/0.jpg',
        'duration': '8:12',
      },
    ];

    final theme = Theme.of(context);

    return ProtectedPage(
      currentIndex: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Приветствие
            Text(
              'Добро пожаловать, изучай языки с LanguaFlow!',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Ты смотришь видео 3 дня подряд 🔥',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Плейлисты
            Text(
              'Темы',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: playlists.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return Chip(
                    backgroundColor: Colors.deepPurple.shade100,
                    label: Text(
                      playlists[index],
                      style: const TextStyle(color: Colors.deepPurple),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Видео
            Expanded(
              child: ListView.separated(
                itemCount: videos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(video['thumbnail']!, width: 100, fit: BoxFit.cover),
                      ),
                      title: Text(video['title']!, style: theme.textTheme.titleMedium),
                      subtitle: Text('Длительность: ${video['duration']}'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Запустить видео / перейти к уроку
                        },
                        child: const Text('Начать'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
