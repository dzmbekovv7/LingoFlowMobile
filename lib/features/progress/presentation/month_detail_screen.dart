import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthDetailScreen extends StatelessWidget {
  final int year;
  final int month;

  const MonthDetailScreen({super.key, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    final monthName = DateFormat.MMMM().format(DateTime(year, month));
    final daysInMonth = DateUtils.getDaysInMonth(year, month);

    // Пример прогресса по дням
    final Map<String, Map<String, dynamic>> dayProgress = {
      '$year-${month.toString().padLeft(2, '0')}-03': {'lessons': 1, 'words': 10, 'score': 60},
      '$year-${month.toString().padLeft(2, '0')}-05': {'lessons': 2, 'words': 20, 'score': 80},
      '$year-${month.toString().padLeft(2, '0')}-10': {'lessons': 3, 'words': 30, 'score': 90},
    };

    final days = List.generate(daysInMonth, (i) => DateTime(year, month, i + 1));

    return Scaffold(
      appBar: AppBar(
        title: Text('📅 $monthName $year'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: days.length,
          itemBuilder: (context, index) {
            final date = days[index];
            final dateStr = DateFormat('yyyy-MM-dd').format(date);
            final data = dayProgress[dateStr] ?? {'lessons': 0, 'words': 0, 'score': 0};
            final isActive = data['score'] > 0;

            return Card(
              color: isActive ? Colors.deepPurple.shade100 : Colors.grey.shade100,
              elevation: isActive ? 4 : 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: isActive ? Colors.deepPurple : Colors.grey),
                title: Text(DateFormat('d MMMM, EEEE', 'ru').format(date)),
                subtitle: Row(
                  children: [
                    Text('📘 ${data['lessons']}   '),
                    Text('🧠 ${data['words']}   '),
                    Text('⭐ ${data['score']}%'),
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
