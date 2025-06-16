import 'package:flutter/material.dart';
import 'package:project/models/nutrition_data.dart';
import 'analytics_time_period_selector.dart';
import 'analytics_calories_overview.dart';
import 'analytics_calories_breakdown.dart';
import 'analytics_calories_chart.dart';
import 'analytics_calories_stats.dart';
import 'analytics_calories_recommendations.dart';

class AnalyticsCaloriesContent extends StatefulWidget {
  final NutritionData nutritionData;
  final DateTime selectedDate;
  
  // Optional: you can still pass real data if available
  final int? realWeeklyConsumed;
  final int? realMonthlyConsumed;

  const AnalyticsCaloriesContent({
    super.key,
    required this.nutritionData,
    required this.selectedDate,
    this.realWeeklyConsumed,
    this.realMonthlyConsumed,
  });

  @override
  State<AnalyticsCaloriesContent> createState() => _AnalyticsCaloriesContentState();
}

class _AnalyticsCaloriesContentState extends State<AnalyticsCaloriesContent> {
  int selectedPeriodIndex = 1; // Month selected by default
  final List<String> periods = ['Day', 'Week', 'Month'];

  // Hardcoded values for other days in the week (6 days)
  static const List<int> hardcodedWeekDays = [
    1747, // Monday (like in your "best day" from image)
    1850, // Tuesday  
    1600, // Wednesday
    1900, // Thursday
    2774, // Friday (like in your "worst day" from image)
    1750, // Saturday
    1800, // Sunday
  ];

  // Hardcoded values for other days in the month (29 days)
  static const List<int> hardcodedMonthDays = [
    1800, 1900, 1750, 1600, 2100, 1850, 1950, // Week 1
    2000, 1900, 1800, 2200, 1750, 1900, 2050, // Week 2
    1850, 2100, 1950, 1800, 2400, 1900, 1850, // Week 3
    2000, 1950, 1800, 2150, 1900, 2250, 1850, 2000, 1950, // Week 4+
  ];

  // Calculate dynamic weekly total: 6 hardcoded days + today's actual
  int get dynamicWeeklyTotal {
    if (widget.realWeeklyConsumed != null) {
      return widget.realWeeklyConsumed!;
    }
    
    final todayCalories = widget.nutritionData.consumedCalories;
    
    // Sum of 6 hardcoded days + today's actual calories
    final hardcodedSum = hardcodedWeekDays.take(6).reduce((a, b) => a + b);
    
    return hardcodedSum + todayCalories;
  }

  // Calculate dynamic monthly total: 29 hardcoded days + today's actual  
  int get dynamicMonthlyTotal {
    if (widget.realMonthlyConsumed != null) {
      return widget.realMonthlyConsumed!;
    }
    
    final todayCalories = widget.nutritionData.consumedCalories;
    
    // Sum of 29 hardcoded days + today's actual calories
    final hardcodedSum = hardcodedMonthDays.take(29).reduce((a, b) => a + b);
    
    return hardcodedSum + todayCalories;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Time Period Selector
        AnalyticsTimePeriodSelector(
          periods: periods,
          selectedIndex: selectedPeriodIndex,
          onPeriodSelected: (index) {
            setState(() {
              selectedPeriodIndex = index;
            });
          },
        ),
        
        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                
                // Calorie Overview - Uses hardcoded + today only
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnalyticsCaloriesOverview(
                    nutritionData: widget.nutritionData,
                    periodIndex: selectedPeriodIndex,
                    realWeeklyConsumed: dynamicWeeklyTotal,     // 6 hardcoded + today
                    realMonthlyConsumed: dynamicMonthlyTotal,   // 29 hardcoded + today
                  ),
                ),
                const SizedBox(height: 12),
                
                // Chart Section - Uses same data
                AnalyticsCaloriesChart(
                  nutritionData: widget.nutritionData,
                  periodIndex: selectedPeriodIndex,
                  realWeeklyTotal: dynamicWeeklyTotal,     // 6 hardcoded + today
                  realMonthlyTotal: dynamicMonthlyTotal,   // 29 hardcoded + today
                ),
                const SizedBox(height: 12),
                
                // Breakdown Section - Uses same data
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnalyticsCaloriesBreakdown(
                    nutritionData: widget.nutritionData,
                    periodIndex: selectedPeriodIndex,
                    dynamicWeeklyTotal: dynamicWeeklyTotal,     // 6 hardcoded + today
                    dynamicMonthlyTotal: dynamicMonthlyTotal,   // 29 hardcoded + today
                  ),
                ),
                const SizedBox(height: 12),
                
                // Statistics Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnalyticsCaloriesStats(
                    nutritionData: widget.nutritionData,
                    periodIndex: selectedPeriodIndex,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Recommendations
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnalyticsCaloriesRecommendations(
                    nutritionData: widget.nutritionData,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}