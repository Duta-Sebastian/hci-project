import 'package:flutter/material.dart';
import 'package:project/models/nutrient_goal.dart';
import 'package:project/models/nutrition_data.dart';
import 'package:project/screens/account_screen.dart';
import 'package:project/screens/add_entry_screen.dart';
import 'package:project/screens/analytics_screen.dart';
import 'package:project/screens/community_screen.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/services/meal_database.dart';
import 'package:project/utils/date_utils.dart';
import 'package:project/widgets/bottom_nav_bar.dart';

class FitnessApp extends StatefulWidget {
  const FitnessApp({super.key});

  @override
  FitnessAppState createState() => FitnessAppState();
}

class FitnessAppState extends State<FitnessApp> {
  int _selectedIndex = 0;
  late PageController _pageController;

  final String userName = "Maria";
  final int streakDays = 5;
  
  late NutritionData nutritionData;
  bool _isLoading = true;

  late DateTime _selectedDate;
  late DateTime _monthStart;
  late List<DateTime> _weekDays;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _pageController = PageController(initialPage: 0);
    _selectedDate = DateTime.now();
    _monthStart = DateTime(_selectedDate.year, _selectedDate.month, 1);
    _weekDays = DateUtil.getWeekDays(_selectedDate);
    debugPrint('Selected date: $_selectedDate');
    nutritionData = NutritionData.defaultGoals();
    _loadNutritionDataForDate(_selectedDate);
  }

  Future<void> _loadNutritionDataForDate(DateTime date) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final totals = await MealDatabase.instance.calculateNutritionTotalsForDate(date);
      
      final consumedCalories = totals['calories'] as int;
      final consumedCarbs = (totals['carbs'] as double).toInt();
      final consumedProtein = (totals['protein'] as double).toInt();
      final consumedFat = (totals['fat'] as double).toInt();
      
      const caloriesGoal = 2300;
      const carbsGoal = 232;
      const proteinGoal = 280;
      const fatGoal = 110;
      
      debugPrint('Nutrition goals: $caloriesGoal calories, $carbsGoal g carbs, $proteinGoal g protein, $fatGoal g fat');
      debugPrint('Meals for date $date: ${totals['meals']}');
      
      if (mounted) {
        setState(() {
          nutritionData = NutritionData(
            totalCalories: caloriesGoal,
            consumedCalories: consumedCalories,
            goals: {
              'Carbs': NutrientGoal(
                target: carbsGoal, 
                current: consumedCarbs, 
                unit: 'g'
              ),
              'Protein': NutrientGoal(
                target: proteinGoal, 
                current: consumedProtein, 
                unit: 'g'
              ),
              'Fat': NutrientGoal(
                target: fatGoal, 
                current: consumedFat, 
                unit: 'g'
              ),
            },
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          nutritionData = NutritionData.defaultGoals();
          _isLoading = false;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onDateSelected(DateTime date) {
    debugPrint("Date selected: $date");
    
    setState(() {
      _selectedDate = date;
      
      // Update week days to contain the selected date
      _weekDays = DateUtil.getWeekDays(date);
      
      // Check if month changed
      if (_selectedDate.month != _monthStart.month || _selectedDate.year != _monthStart.year) {
        _monthStart = DateTime(_selectedDate.year, _selectedDate.month, 1);
      }
    });
    
    _loadNutritionDataForDate(date);
  }

  void _onMonthChanged(DateTime month) {
    debugPrint("Month changed to: ${month.year}-${month.month}");
    
    // Using the exact date that was picked from the date picker
    DateTime selectedDate = month;
    
    setState(() {
      _monthStart = DateTime(month.year, month.month, 1);
      _selectedDate = selectedDate;
      
      // Update week days to contain the selected date
      _weekDays = DateUtil.getWeekDays(selectedDate);
    });
    
    _loadNutritionDataForDate(selectedDate);
  }
  
  void _onWeekChanged(List<DateTime> weekDays) {
    setState(() {
      _weekDays = weekDays;
      
      // Determine the dominant month in this week
      Map<int, int> monthCount = {};
      for (var day in weekDays) {
        int monthKey = day.month + day.year * 100; // Unique key for year-month combination
        monthCount[monthKey] = (monthCount[monthKey] ?? 0) + 1;
      }
      
      // Find month with most days in this week
      int maxDays = 0;
      int dominantMonthKey = 0;
      monthCount.forEach((key, count) {
        if (count > maxDays) {
          maxDays = count;
          dominantMonthKey = key;
        }
      });
      
      // Extract year and month from the key
      int year = dominantMonthKey ~/ 100;
      int month = dominantMonthKey % 100;
      
      // Only update month view if the dominant month changed
      if (_monthStart.month != month || _monthStart.year != year) {
        _monthStart = DateTime(year, month, 1);
      }
    });
  }
  
  void _onDataChanged() {
    _loadNutritionDataForDate(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    // Calculate visibility once to ensure consistency
    final bool showFAB = DateUtil.isSameDay(_selectedDate, DateTime.now()) && _selectedIndex == 0;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            HomeScreen(
              userName: userName,
              streakDays: streakDays,
              nutritionData: nutritionData,
              selectedDate: _selectedDate,
              monthStart: _monthStart,
              weekDays: _weekDays, 
              onDateSelected: _onDateSelected,
              onMonthChanged: _onMonthChanged,
              onWeekChanged: _onWeekChanged,
              onDataChanged: _onDataChanged,
            ),
            const AnalyticsScreen(),
            const CommunityScreen(),
            const AccountScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        isFABVisible: showFAB,
      ),
      floatingActionButton: showFAB
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEntryScreen(
                      onDataChanged: _onDataChanged,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.purple.shade300,
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}