import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:lingoo/shared/widgets/protected_page.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, List<Map<String, String>>> languageVideos = {};
  List<String> languageTabs = [];
  String? selectedLanguage;
  bool isLoading = true;
  String? name;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchVideos();
  }

  Future<void> fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;
    final decoded = JwtDecoder.decode(token);
    setState(() {
      name = decoded['name'] ?? 'Learner';
    });
  }

  Future<void> fetchVideos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No token found');

      final res = await Dio().get(
        'http://192.168.56.1:3333/videos',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final Map<String, dynamic> data = res.data;
      if (data.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      List<String> langs = data.keys.toList();
      selectedLanguage = langs.first;

      Map<String, List<Map<String, String>>> grouped = {};

      for (final lang in langs) {
        final List items = data[lang];
        grouped[lang] = items.map<Map<String, String>>((item) {
          final snippet = item['snippet'];
          final videoId = item['id']['videoId'];
          return {
            'title': snippet['title'] ?? 'Untitled',
            'thumbnail': snippet['thumbnails']['medium']['url'],
            'duration': '⏳',
            'videoId': videoId,
          };
        }).toList();
      }

      setState(() {
        languageVideos = grouped;
        languageTabs = langs;
        isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки видео: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showVideoPlayer(BuildContext context, String videoId, String title) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: YoutubePlayerBuilder(
            player: YoutubePlayer(controller: _controller),
            builder: (context, player) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade100,
                      Colors.purple.shade50,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.shade100,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Welcome, ${name ?? 'Learner'} 👋",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.purple.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Pick a language and explore lessons 🎓",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.purple.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // LANGUAGE TABS
              if (languageTabs.isNotEmpty)
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: languageTabs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final lang = languageTabs[index];
                      final isSelected = lang == selectedLanguage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        child: ChoiceChip(
                          label: Text(lang),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              selectedLanguage = lang;
                            });
                          },
                          selectedColor: Colors.deepPurple,
                          backgroundColor: Colors.deepPurple.shade100,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),

              // VIDEO LIST
              isLoading
                  ? const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: Colors.deepPurple,
                  ),
                ),
              )
                  : selectedLanguage == null ||
                  languageVideos[selectedLanguage!] == null
                  ? const Expanded(
                child: Center(
                  child: Text("No videos found"),
                ),
              )
                  : Expanded(
                child: ListView.separated(
                  itemCount:
                  languageVideos[selectedLanguage!]!.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    final video =
                    languageVideos[selectedLanguage!]![index];
                    return GestureDetector(
                      onTap: () => _showVideoPlayer(
                        context,
                        video['videoId']!,
                        video['title']!,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.shade100,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                video['thumbnail']!,
                                width: 110,
                                height: 75,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video['title']!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme
                                        .textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                      Colors.deepPurple.shade900,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.timer,
                                        size: 16,
                                        color: Colors.deepPurple,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        video['duration']!,
                                        style:
                                        theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.play_circle_fill_rounded,
                                color: Colors.deepPurple,
                                size: 30,
                              ),
                              onPressed: () => _showVideoPlayer(
                                context,
                                video['videoId']!,
                                video['title']!,
                              ),
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
      ),
    );
  }
}
