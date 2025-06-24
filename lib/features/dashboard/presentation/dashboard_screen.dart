import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:lingoo/shared/widgets/protected_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> playlists = ['Beginner', 'Intermediate', 'Advanced'];
  String selectedPlaylist = 'Beginner';

  final List<Map<String, String>> videos = [
    {
      'title': 'Lesson 1: Greetings',
      'thumbnail': 'https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg',
      'duration': '10:23',
      'videoId': 'dQw4w9WgXcQ',
    },
    {
      'title': 'Lesson 2: Grammar Basics',
      'thumbnail': 'https://img.youtube.com/vi/3JZ_D3ELwOQ/0.jpg',
      'duration': '8:12',
      'videoId': '3JZ_D3ELwOQ',
    },
    {
      'title': 'Lesson 3: Common Phrases',
      'thumbnail': 'https://img.youtube.com/vi/tVj0ZTS4WF4/0.jpg',
      'duration': '12:45',
      'videoId': 'tVj0ZTS4WF4',
    },
  ];

  void _showVideoPlayer(BuildContext context, String videoId, String title) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        controlsVisibleAtStart: true,
      ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(16),
          child: YoutubePlayerBuilder(
            player: YoutubePlayer(controller: _controller),
            builder: (context, player) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: player,
                  ),
                ],
              );
            },
          ),
        );
      },
    ).whenComplete(() => _controller.pause());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProtectedPage(
      currentIndex: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to LanguaFlow!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re on a 3-day video streak 🔥',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),

            Text(
              'Playlists',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: playlists.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  final isSelected = playlist == selectedPlaylist;

                  return ChoiceChip(
                    label: Text(
                      playlist,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.deepPurple,
                    backgroundColor: Colors.deepPurple.shade100,
                    onSelected: (selected) {
                      setState(() => selectedPlaylist = playlist);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: ListView.separated(
                itemCount: videos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final video = videos[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: Colors.deepPurple.withOpacity(0.25),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              video['thumbnail']!,
                              width: 100,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  video['title']!,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text('Duration: ${video['duration']}',
                                    style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              _showVideoPlayer(context, video['videoId']!, video['title']!);
                            },
                            child: const Text('Watch'),
                          ),
                        ],
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
