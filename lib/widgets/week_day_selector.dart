import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/date_utils.dart';

class WeekDaySelector extends StatelessWidget {
  final List<DateTime> weekDays;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const WeekDaySelector({
    super.key,
    required this.weekDays,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          weekDays.length,
          (index) => _buildWeekDay(
            context,
            weekDays[index],
            isSelected: DateUtil.isSameDay(weekDays[index], selectedDate),
          ),
        ),
      ),
    );
  }

  Widget _buildWeekDay(BuildContext context, DateTime date, {bool isSelected = false}) {
    final dayName = DateFormat('E').format(date).substring(0, 3);
    final dayNumber = date.day.toString();
    
    return InkWell(
      onTap: () => onDateSelected(date),
      child: Column(
        children: [
          Text(
            dayName,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.purple : Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.purple.shade300 : Colors.transparent,
            ),
            child: Center(
              child: Text(
                dayNumber,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}