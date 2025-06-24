import 'package:flutter/material.dart';
import 'package:lingoo/shared/widgets/protected_page.dart';
import 'package:dio/dio.dart';
import '../../../core/services/auth_provider.dart';
import 'package:provider/provider.dart';

class VocabScreen extends StatefulWidget {
  const VocabScreen({Key? key}) : super(key: key);

  @override
  State<VocabScreen> createState() => _VocabScreenState();
}

class _VocabScreenState extends State<VocabScreen> {
  Map<String, List<Map<String, dynamic>>> groupedVocab = {};
  List<String> allCategories = [];
  String? selectedCategory;
  bool isLoading = true;

  late String userId;
  late String token;

  final String apiUrl = 'http://192.168.56.1:3333/vocabulary';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      userId = authProvider.userId ?? '';
      token = authProvider.token ?? '';

      if (userId.isEmpty || token.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      fetchUserLanguageAndVocab();
    });
  }

  Future<void> fetchUserLanguageAndVocab() async {
    try {
      final profileResponse = await Dio().get(
        'http://192.168.56.1:3333/users/profile/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final targetLanguages = profileResponse.data['targetLanguage'] as List<dynamic>? ?? [];

      if (targetLanguages.isEmpty) {
        setState(() => isLoading = false);
        return;
      }

      Map<String, List<Map<String, dynamic>>> allGrouped = {};
      Set<String> categoriesSet = {};

      for (var lang in targetLanguages) {
        final vocabResponse = await Dio().get('$apiUrl/$userId/$lang');
        final words = List<Map<String, dynamic>>.from(vocabResponse.data);

        allGrouped[lang] = words;

        // Собираем категории из слов
        for (var w in words) {
          if (w['category'] != null && w['category'] is String) {
            categoriesSet.add(w['category']);
          }
        }
      }

      setState(() {
        groupedVocab = allGrouped;
        allCategories = categoriesSet.toList()..sort();
        selectedCategory = null; // пока ничего не выбрано
        isLoading = false;
      });
    } catch (e) {
      print('Error loading vocabulary or profile: $e');
      setState(() => isLoading = false);
    }
  }

  // Фильтруем слова по выбранной категории
  Map<String, List<Map<String, dynamic>>> get filteredVocab {
    if (selectedCategory == null) return groupedVocab;

    final Map<String, List<Map<String, dynamic>>> filtered = {};
    groupedVocab.forEach((lang, words) {
      final filteredWords = words.where((w) => w['category'] == selectedCategory).toList();
      if (filteredWords.isNotEmpty) filtered[lang] = filteredWords;
    });
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return ProtectedPage(
      currentIndex: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📘 My Vocabulary',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (groupedVocab.isEmpty)
              const Center(child: Text('No words yet.'))
            else ...[
                // Кнопки категорий
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Кнопка "Все"
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: const Text('All categories'),
                          selected: selectedCategory == null,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = null;
                            });
                          },
                        ),
                      ),
                      // Кнопки категорий из слов
                      ...allCategories.map((cat) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: selectedCategory == cat,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = selected ? cat : null;
                            });
                          },
                        ),
                      ))
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Список слов сгруппированный по языкам
                Expanded(
                  child: filteredVocab.isEmpty
                      ? const Center(child: Text('No words for this category.'))
                      : ListView(
                    children: filteredVocab.entries.map((entry) {
                      final lang = entry.key;
                      final words = entry.value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: Column(
                                key: ValueKey(lang + (selectedCategory ?? 'all')),
                                children: words.map((word) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        word['isDefault'] == true
                                            ? Icons.auto_stories
                                            : Icons.edit_note,
                                        color: word['isDefault'] == true
                                            ? Colors.blue
                                            : Colors.green,
                                      ),
                                      title: Text(
                                        word['word'] ?? '',
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Translation: ${word['translation']}'),
                                          Text('Type: ${word['type'] ?? "—"}'),
                                          Text('Category: ${word['category'] ?? "—"}'),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
          ],
        ),
      ),
    );
  }
}
