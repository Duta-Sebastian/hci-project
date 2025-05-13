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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              weekDays.length,
              (index) => SizedBox(
                width: (constraints.maxWidth - 16) / weekDays.length,
                child: _buildWeekDay(
                  context,
                  weekDays[index],
                  isSelected: DateUtil.isSameDay(weekDays[index], selectedDate),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeekDay(BuildContext context, DateTime date, {bool isSelected = false}) {
    final dayName = DateFormat('E').format(date).substring(0, 3);
    final dayNumber = date.day.toString();
    
    return InkWell(
      onTap: () => onDateSelected(date),
      borderRadius: BorderRadius.circular(18),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              width: 32,
              height: 32,
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
      ),
    );
  }
}