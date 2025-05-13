import 'package:flutter/material.dart';
import 'package:project/models/nutrition_data.dart';
import 'package:project/widgets/calorie_progress_circle.dart';
import 'package:project/widgets/daily_meals.dart';
import 'package:project/widgets/header_section.dart';
import 'package:project/widgets/month_streak_section.dart';
import 'package:project/widgets/nutrient_progress_bar.dart';
import 'package:project/widgets/week_day_selector_container.dart'; // Using a container widget

class HomeScreen extends StatefulWidget {
  final String userName;
  final int streakDays;
  final NutritionData nutritionData;
  final DateTime selectedDate;
  final DateTime monthStart;
  final List<DateTime> weekDays;
  final Function(DateTime) onDateSelected;
  final Function(DateTime) onMonthChanged;
  final Function(List<DateTime>) onWeekChanged;
  final VoidCallback onDataChanged;

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
    required this.onWeekChanged,
    required this.onDataChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed header section
            Column(
              children: [
                // Header section with profile and notifications
                HeaderSection(userName: widget.userName),
                
                const SizedBox(height: 8),
                
                // Month selector and streak badge
                MonthStreakSection(
                  monthStart: widget.monthStart,
                  streakDays: widget.streakDays,
                  onMonthChanged: widget.onMonthChanged,
                ),
                
                const SizedBox(height: 20),
                
                // Using a container widget for WeekDaySelector that handles rebuilding internally
                WeekDaySelectorContainer(
                  weekDays: widget.weekDays,
                  selectedDate: widget.selectedDate,
                  onDateSelected: widget.onDateSelected,
                  onWeekChanged: widget.onWeekChanged,
                ),
                
                const SizedBox(height: 10),
              ],
            ),
            
            // Scrollable content section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CalorieProgressCircle(
                        caloriesLeft: widget.nutritionData.caloriesLeft,
                        totalCalories: widget.nutritionData.totalCalories,
                        consumedCalories: widget.nutritionData.consumedCalories,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Macronutrients section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: widget.nutritionData.goals.entries.map((entry) {
                          final nutrient = entry.key;
                          final goal = entry.value;
                          return NutrientProgressBar(
                            title: nutrient,
                            current: goal.current,
                            target: goal.target,
                            unit: goal.unit,
                            progress: goal.progress,
                          );
                        }).toList(),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    DailyMealsWidget(
                      selectedDate: widget.selectedDate,
                      onDataChanged: widget.onDataChanged,
                    ),                  
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}