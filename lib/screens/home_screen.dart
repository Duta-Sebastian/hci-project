import 'package:flutter/material.dart';
import 'package:project/models/nutrition_data.dart';
import 'package:project/widgets/calorie_progress_circle.dart';
import 'package:project/widgets/daily_meals.dart';
import 'package:project/widgets/header_section.dart';
import 'package:project/widgets/month_streak_section.dart';
import 'package:project/widgets/nutrient_progress_bar.dart';
import 'package:project/widgets/week_day_selector_container.dart';

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
  final Function(VoidCallback) onMealsRefreshCallbackSet; // Add this parameter

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
    required this.onMealsRefreshCallbackSet, // Add this parameter
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  
  // Cache the header widgets to prevent unnecessary rebuilds
  Widget? _cachedHeaderSection;
  Widget? _cachedMonthStreakSection;
  Widget? _cachedWeekDaySelector;
  
  // Keys for stable widget identity
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _monthStreakKey = GlobalKey();
  final GlobalKey _weekDayKey = GlobalKey();
  final GlobalKey _mealsKey = GlobalKey();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _buildCachedWidgets();
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Only rebuild cached widgets if their relevant data has changed
    bool shouldRebuildHeader = oldWidget.userName != widget.userName;
    bool shouldRebuildMonthStreak = oldWidget.monthStart != widget.monthStart || 
                                   oldWidget.streakDays != widget.streakDays;
    bool shouldRebuildWeekDay = oldWidget.weekDays != widget.weekDays || 
                               oldWidget.selectedDate != widget.selectedDate;

    if (shouldRebuildHeader || shouldRebuildMonthStreak || shouldRebuildWeekDay) {
      _buildCachedWidgets();
    }
  }

  void _buildCachedWidgets() {
    _cachedHeaderSection = HeaderSection(
      key: _headerKey,
      userName: widget.userName,
    );
    
    _cachedMonthStreakSection = MonthStreakSection(
      key: _monthStreakKey,
      monthStart: widget.monthStart,
      streakDays: widget.streakDays,
      onMonthChanged: widget.onMonthChanged,
    );
    
    _cachedWeekDaySelector = WeekDaySelectorContainer(
      key: _weekDayKey,
      weekDays: widget.weekDays,
      selectedDate: widget.selectedDate,
      onDateSelected: widget.onDateSelected,
      onWeekChanged: widget.onWeekChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed header section - use cached widgets
            _buildFixedHeader(),
            
            // Scrollable content section with preserved scroll position
            Expanded(
              child: NotificationListener<ScrollNotification>(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(), // Prevents bounce for smoother experience
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      
                      // Nutrition circle - wrap in its own widget to isolate updates
                      _NutritionSection(nutritionData: widget.nutritionData),
                      
                      const SizedBox(height: 20),
                      
                      // Meals section with callback-based refresh
                      DailyMealsWidget(
                        key: _mealsKey,
                        selectedDate: widget.selectedDate,
                        onDataChanged: widget.onDataChanged,
                        onRefreshCallbackSet: widget.onMealsRefreshCallbackSet,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedHeader() {
    return Column(
      children: [
        // Header section with profile and notifications
        _cachedHeaderSection!,
        
        const SizedBox(height: 8),
        
        // Month selector and streak badge
        _cachedMonthStreakSection!,
        
        const SizedBox(height: 20),
        
        // Week day selector
        _cachedWeekDaySelector!,
        
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// Separate widget for nutrition section to isolate updates
class _NutritionSection extends StatelessWidget {
  final NutritionData nutritionData;

  const _NutritionSection({required this.nutritionData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Calorie progress circle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CalorieProgressCircle(
            caloriesLeft: nutritionData.caloriesLeft,
            totalCalories: nutritionData.totalCalories,
            consumedCalories: nutritionData.consumedCalories,
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Macronutrients section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: nutritionData.goals.entries.map((entry) {
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
      ],
    );
  }
}