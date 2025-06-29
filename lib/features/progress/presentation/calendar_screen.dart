import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'month_detail_screen.dart';

class ProgressCalendarScreen extends StatelessWidget {
  const ProgressCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentYear = now.year;

    final List<String> monthNames = List.generate(12, (i) {
      final monthDate = DateTime(currentYear, i + 1);
      return DateFormat.MMMM().format(monthDate);
    });

    final Map<int, Map<String, dynamic>> monthlyProgress = {
      1: {'lessons': 20, 'score': 80},
      2: {'lessons': 5, 'score': 40},
      6: {'lessons': 12, 'score': 60},
      7: {'lessons': 18, 'score': 90},
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('📅 Прогресс по месяцам'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: 12,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final monthIndex = index + 1;
            final data = monthlyProgress[monthIndex] ?? {'lessons': 0, 'score': 0};
            final isActive = data['score'] > 0;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MonthDetailScreen(
                      year: currentYear,
                      month: monthIndex,
                    ),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: isActive
                      ? const LinearGradient(
                    colors: [Color(0xFF7E57C2), Color(0xFF9575CD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : LinearGradient(
                    colors: [Colors.grey.shade200, Colors.grey.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    if (isActive)
                      const BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      monthNames[index],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.white : Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    _StatRow(icon: '📘', label: '${data['lessons']} уроков', active: isActive),
                    const SizedBox(height: 6),
                    _StatRow(icon: '⭐', label: '${data['score']}%', active: isActive),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String icon;
  final String label;
  final bool active;

  const _StatRow({required this.icon, required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          icon,
          style: TextStyle(
            fontSize: 18,
            color: active ? Colors.white : Colors.grey[700],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: active ? Colors.white : Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
