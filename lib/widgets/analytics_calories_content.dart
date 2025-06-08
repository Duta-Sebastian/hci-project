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

  const AnalyticsCaloriesContent({
    super.key,
    required this.nutritionData,
    required this.selectedDate,
  });

  @override
  State<AnalyticsCaloriesContent> createState() => _AnalyticsCaloriesContentState();
}

class _AnalyticsCaloriesContentState extends State<AnalyticsCaloriesContent> {
  int selectedPeriodIndex = 1; // Month selected by default
  final List<String> periods = ['Day', 'Week', 'Month'];

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
        
        // Scrollable Content - FIXED WITH PROPER SCROLLING
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8), // Reduced from 20
                
                // Calorie Goal Overview
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnalyticsCaloriesOverview(
                    nutritionData: widget.nutritionData,
                    periodIndex: selectedPeriodIndex,
                  ),
                ),
                const SizedBox(height: 12), // Reduced from 24
                
                // Chart Section
                AnalyticsCaloriesChart(
                  nutritionData: widget.nutritionData,
                  periodIndex: selectedPeriodIndex,
                ),
                const SizedBox(height: 12), // Reduced from 24
                
                // Breakdown Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnalyticsCaloriesBreakdown(
                    nutritionData: widget.nutritionData,
                    periodIndex: selectedPeriodIndex,
                  ),
                ),
                const SizedBox(height: 12), // Reduced from 24
                
                // Statistics Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnalyticsCaloriesStats(
                    nutritionData: widget.nutritionData,
                    periodIndex: selectedPeriodIndex,
                  ),
                ),
                const SizedBox(height: 12), // Reduced from 24
                
                // Recommendations
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnalyticsCaloriesRecommendations(
                    nutritionData: widget.nutritionData,
                  ),
                ),
                const SizedBox(height: 16), // Bottom padding
              ],
            ),
          ),
        ),
      ],
    );
  }
}