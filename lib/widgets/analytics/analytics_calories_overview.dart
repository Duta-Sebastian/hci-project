import 'package:flutter/material.dart';
import 'package:project/models/nutrition_data.dart';

class AnalyticsCaloriesOverview extends StatelessWidget {
  final NutritionData nutritionData;
  final int periodIndex;
  
  // Add these parameters to get real consumed data
  final int? realWeeklyConsumed;
  final int? realMonthlyConsumed;

  const AnalyticsCaloriesOverview({
    super.key,
    required this.nutritionData,
    required this.periodIndex,
    this.realWeeklyConsumed,    // Pass real weekly consumed here
    this.realMonthlyConsumed,   // Pass real monthly consumed here
  });

  @override
  Widget build(BuildContext context) {
    // Get data based on period and real nutrition data
    Map<String, dynamic> data = _getDataForPeriod(periodIndex);
        
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display consumed calories (not goal)
        Row(
          children: [
            Text(
              '${data['consumed']}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              data['consumedLabel'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Map<String, dynamic> _getDataForPeriod(int periodIndex) {
    switch (periodIndex) {
      case 0: // Day - Use REAL consumed calories
        return {
          'consumed': nutritionData.consumedCalories,
          'consumedLabel': 'kcal today',
        };
      case 1: // Week - Use REAL weekly consumed
        final weeklyConsumed = realWeeklyConsumed ?? 14385; // Same fallback as chart
        return {
          'consumed': weeklyConsumed,
          'consumedLabel': 'kcal this week',
        };
      case 2: // Month - Use REAL monthly consumed
      default:
        final monthlyConsumed = realMonthlyConsumed ?? 61650;
        return {
          'consumed': monthlyConsumed,
          'consumedLabel': 'kcal this month',
        };
    }
  }
}