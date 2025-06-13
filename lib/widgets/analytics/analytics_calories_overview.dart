import 'package:flutter/material.dart';
import 'package:project/models/nutrition_data.dart';

class AnalyticsCaloriesOverview extends StatelessWidget {
  final NutritionData nutritionData;
  final int periodIndex;

  const AnalyticsCaloriesOverview({
    super.key,
    required this.nutritionData,
    required this.periodIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Get data based on period and real nutrition data
    Map<String, dynamic> data = _getDataForPeriod(periodIndex);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Goal Display
        Row(
          children: [
            Text(
              '${data['goal']}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              data['goalLabel'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Current Progress
        Row(
          children: [
            Text(
              '${data['current']}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${data['percentage']}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Map<String, dynamic> _getDataForPeriod(int periodIndex) {
    switch (periodIndex) {
      case 0: // Day - Use REAL data from FitnessApp
        final percentage = nutritionData.totalCalories > 0 
            ? ((nutritionData.consumedCalories / nutritionData.totalCalories) * 100).round()
            : 0;
        return {
          'goal': nutritionData.totalCalories,
          'goalLabel': 'kcal recommended',
          'current': nutritionData.consumedCalories,
          'percentage': percentage,
        };
      case 1: // Week (estimated)
        final weeklyGoal = nutritionData.totalCalories * 7;
        final weeklyConsumed = (nutritionData.consumedCalories * 6.8).round(); // Estimate
        final weeklyPercentage = weeklyGoal > 0 
            ? ((weeklyConsumed / weeklyGoal) * 100).round()
            : 0;
        return {
          'goal': weeklyGoal,
          'goalLabel': 'kcal this week',
          'current': weeklyConsumed,
          'percentage': weeklyPercentage,
        };
      case 2: // Month (estimated)
      default:
        final monthlyGoal = nutritionData.totalCalories * 30;
        final monthlyConsumed = (nutritionData.consumedCalories * 28.5).round(); // Estimate
        final monthlyPercentage = monthlyGoal > 0 
            ? ((monthlyConsumed / monthlyGoal) * 100).round()
            : 0;
        return {
          'goal': monthlyGoal,
          'goalLabel': 'kcal this month',
          'current': monthlyConsumed,
          'percentage': monthlyPercentage,
        };
    }
  }
}
