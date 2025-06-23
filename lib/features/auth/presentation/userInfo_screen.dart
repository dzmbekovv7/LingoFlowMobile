import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

class UserInfoScreen extends StatefulWidget {
  final String userId;
  final String token;

  const UserInfoScreen({Key? key, required this.userId, required this.token}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  List<String> allLanguages = [];
  List<String> allLevels = [];
  List<String> allInterests = [];

  String? nativeLanguage;
  List<String> targetLanguages = [];
  String? level;
  String goals = '';
  List<String> selectedInterests = [];

  bool isLoading = true;
  bool isSubmitting = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchLists();
  }

  Future<void> fetchLists() async {
    try {
      final dio = Dio();
      // Предполагаемые эндпоинты, исправь если другие
      final langsRes = await dio.get('http://192.168.56.1:3333/languages/languages');
      final levelsRes = await dio.get('http://192.168.56.1:3333/languages/levels');
      final interestsRes = await dio.get('http://192.168.56.1:3333/languages/interests');

      setState(() {
        allLanguages = List<String>.from(langsRes.data);
        allLevels = List<String>.from(levelsRes.data);
        allInterests = List<String>.from(interestsRes.data);
        isLoading = false;
      });
    } catch (e) {
      // Ошибка загрузки списков
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки данных: $e')),
      );
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (nativeLanguage == null || level == null || targetLanguages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните все обязательные поля')),
      );
      return;
    }

    setState(() => isSubmitting = true);
    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${widget.token}';

      await dio.patch(
        'http://192.168.56.1:3333/users/profile/${widget.userId}',
        data: {
          "nativeLanguage": nativeLanguage,
          "targetLanguage": targetLanguages,
          "level": level,
          "goals": goals,
          "interests": selectedInterests,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Данные успешно сохранены!')),
      );

      context.go('/home');

      // Тут можно перейти дальше или закрыть экран
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка отправки данных: $e')),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // мягкий бело-розовый фон
      appBar: AppBar(
        title: const Text('Расскажите о себе'),
        backgroundColor: const Color(0xFF6A0DAD), // фиолетовый
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6A0DAD)))
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Родной язык
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Ваш родной язык',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                value: nativeLanguage,
                items: allLanguages
                    .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                    .toList(),
                onChanged: (v) => setState(() => nativeLanguage = v),
                validator: (v) => v == null ? 'Пожалуйста, выберите язык' : null,
              ),
              const SizedBox(height: 20),

              // Языки для изучения (мультивыбор)
              Text('Языки, которые хотите изучать', style: theme.textTheme.titleMedium),
              Wrap(
                spacing: 8,
                children: allLanguages.map((lang) {
                  final selected = targetLanguages.contains(lang);
                  return FilterChip(
                    label: Text(lang),
                    selected: selected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          targetLanguages.add(lang);
                        } else {
                          targetLanguages.remove(lang);
                        }
                      });
                    },
                    selectedColor: const Color(0xFF6A0DAD).withOpacity(0.3),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Уровень
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Ваш уровень',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                value: level,
                items: allLevels
                    .map((lvl) => DropdownMenuItem(value: lvl, child: Text(lvl)))
                    .toList(),
                onChanged: (v) => setState(() => level = v),
                validator: (v) => v == null ? 'Пожалуйста, выберите уровень' : null,
              ),
              const SizedBox(height: 20),

              // Цель (текст)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Ваша цель',
                  hintText: 'Например: хочу смотреть фильмы на языке оригинала',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 3,
                onChanged: (v) => goals = v,
              ),
              const SizedBox(height: 20),

              // Интересы (мультивыбор)
              Text('Ваши интересы', style: theme.textTheme.titleMedium),
              Wrap(
                spacing: 8,
                children: allInterests.map((interest) {
                  final selected = selectedInterests.contains(interest);
                  return FilterChip(
                    label: Text(interest),
                    selected: selected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          selectedInterests.add(interest);
                        } else {
                          selectedInterests.remove(interest);
                        }
                      });
                    },
                    selectedColor: const Color(0xFF6A0DAD).withOpacity(0.3),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: isSubmitting ? null : submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A0DAD),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Продолжить', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
