import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthStreakSection extends StatelessWidget {
  final DateTime monthStart;
  final int streakDays;
  final Function(DateTime) onMonthChanged;

  const MonthStreakSection({
    super.key,
    required this.monthStart,
    required this.streakDays,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
                    // Streak badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue.shade50,
            ),
            child: Row(
              children: [
                Text(
                  '$streakDays days streak',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
              ],
            ),
          ),
          // Month dropdown
          InkWell(
            onTap: () => _showMonthPicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text(DateFormat('MMMM').format(monthStart)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_drop_down, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMonthPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: monthStart,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      onMonthChanged(DateTime(picked.year, picked.month, 1));
    }
  }
}