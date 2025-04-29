import 'package:flutter/material.dart';
import 'package:project/models/nutrition_data.dart';
import 'package:project/widgets/calorie_progres_circle.dart';
import 'package:project/widgets/header_section.dart';
import 'package:project/widgets/month_streak_section.dart';
import 'package:project/widgets/nutrient_progress_bar.dart';
import 'package:project/widgets/week_day_selector.dart';


class HomeScreen extends StatelessWidget {
  final String userName;
  final int streakDays;
  final NutritionData nutritionData;
  final DateTime selectedDate;
  final DateTime monthStart;
  final List<DateTime> weekDays;
  final Function(DateTime) onDateSelected;
  final Function(DateTime) onMonthChanged;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.streakDays,
    required this.nutritionData,
    required this.selectedDate,
    required this.monthStart,
    required this.weekDays,
    required this.onDateSelected,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header section with profile and notifications
        HeaderSection(userName: userName),
        
        const SizedBox(height: 8),
        
        // Month selector and streak badge
        MonthStreakSection(
          monthStart: monthStart,
          streakDays: streakDays,
          onMonthChanged: onMonthChanged,
        ),
        
        const SizedBox(height: 20),
        
        // Week calendar
        WeekDaySelector(
          weekDays: weekDays,
          selectedDate: selectedDate,
          onDateSelected: onDateSelected,
        ),
        
        const SizedBox(height: 30),
        
        // Calories progress circle
        CalorieProgressCircle(
          caloriesLeft: nutritionData.caloriesLeft,
          totalCalories: nutritionData.totalCalories,
          consumedCalories: nutritionData.consumedCalories,
        ),
        
        const SizedBox(height: 20),
        
        // Macronutrients section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: nutritionData.goals.entries.map((entry) {
              final nutrient = entry.key;
              final goal = entry.value;
              return NutrientProgressBar(
                title: nutrient,
                current: goal.current,
                target: goal.target,
                unit: goal.unit,
                progress: goal.progress,
                color: _getNutrientColor(nutrient),
              );
            }).toList(),
          ),
        ),
        
        const Spacer(),
      ],
    );
  }

  Color _getNutrientColor(String nutrient) {
    switch (nutrient) {
      case 'Carbs':
        return Colors.purple;
      case 'Protein':
        return Colors.green;
      case 'Fat':
        return Colors.green.shade300;
      default:
        return Colors.blue;
    }
  }
}