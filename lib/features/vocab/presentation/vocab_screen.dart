// lib/features/vocab/presentation/vocab_screen.dart
import 'package:flutter/material.dart';
import 'package:lingoo/shared/widgets/protected_page.dart';

class VocabScreen extends StatelessWidget {
  const VocabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vocabList = [
      {'word': 'hello', 'translation': 'привет'},
      {'word': 'world', 'translation': 'мир'},
      {'word': 'apple', 'translation': 'яблоко'},
      {'word': 'language', 'translation': 'язык'},
      {'word': 'computer', 'translation': 'компьютер'},
    ];

    return ProtectedPage(
      currentIndex: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📘 My Vocabulary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: vocabList.length,
                itemBuilder: (context, index) {
                  final word = vocabList[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.language, color: Colors.blue),
                      title: Text(
                        word['word']!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text('Translation: ${word['translation']}'),
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
