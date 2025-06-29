// Новый файл: progress_screen.dart
import 'package:flutter/material.dart';
import './calendar_screen.dart';
import 'dart:math';
import 'package:go_router/go_router.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int selectedWeek = 0; // 0 - текущая неделя, 1 - предыдущая и т.д.

  List<List<Map<String, dynamic>>> weeklyProgress = [
    // Текущая неделя (пример)
    [
      {'date': 'Mon', 'lessons': 2, 'words': 15, 'score': 85},
      {'date': 'Tue', 'lessons': 1, 'words': 7, 'score': 70},
      {'date': 'Wed', 'lessons': 0, 'words': 0, 'score': 0},
      {'date': 'Thu', 'lessons': 3, 'words': 22, 'score': 88},
      {'date': 'Fri', 'lessons': 1, 'words': 10, 'score': 75},
      {'date': 'Sat', 'lessons': 2, 'words': 14, 'score': 82},
      {'date': 'Sun', 'lessons': 0, 'words': 0, 'score': 0},
    ],
    // Предыдущая неделя
    [
      {'date': 'Mon', 'lessons': 1, 'words': 5, 'score': 60},
      {'date': 'Tue', 'lessons': 2, 'words': 12, 'score': 78},
      {'date': 'Wed', 'lessons': 3, 'words': 20, 'score': 90},
      {'date': 'Thu', 'lessons': 2, 'words': 10, 'score': 80},
      {'date': 'Fri', 'lessons': 1, 'words': 7, 'score': 68},
      {'date': 'Sat', 'lessons': 0, 'words': 0, 'score': 0},
      {'date': 'Sun', 'lessons': 0, 'words': 0, 'score': 0},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final data = weeklyProgress[selectedWeek];
    final average = data.map((d) => d['score'] as int).where((s) => s > 0).toList();
    final averageScore =
    average.isEmpty ? 0 : (average.reduce((a, b) => a + b) / average.length).round();

    return Scaffold(
      appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.go('/profile');
        },
      ),
      title: const Text('Weekly Progress'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProgressCalendarScreen()),
          ),
        ),
      ],
    ),

      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: selectedWeek > 0
                    ? () => setState(() => selectedWeek--)
                    : null,
                child: const Text('< Prev Week'),
              ),
              const SizedBox(width: 16),
              Text(
                selectedWeek == 0 ? 'This Week' : 'Week -$selectedWeek',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: selectedWeek < weeklyProgress.length - 1
                    ? () => setState(() => selectedWeek++)
                    : null,
                child: const Text('Next Week >'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('📘 Lessons: ${data.fold<int>(0, (a, b) => a + (b['lessons'] as int))}'),
                  Text('🧠 Words: ${data.fold<int>(0, (a, b) => a + (b['words'] as int))}'),
                  Text('⭐ Avg: $averageScore%'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('📊 Score Comparison',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          SizedBox(
            height: 140,
            child: CustomPaint(
              painter: _LineChartPainter(data),
              child: Container(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (_, i) => ListTile(
                title: Text('${data[i]['date']}'),
                subtitle: Text('Lessons: ${data[i]['lessons']}, Words: ${data[i]['words']}'),
                trailing: Text('${data[i]['score']}%'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  _LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepPurple
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.fill;

    final stepX = size.width / (data.length - 1);
    final maxY = 100;
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height * (1 - (data[i]['score'] / maxY));
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (var p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }

    canvas.drawPath(path, paint);
    for (final p in points) {
      canvas.drawCircle(p, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
