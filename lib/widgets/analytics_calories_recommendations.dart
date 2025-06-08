import 'package:flutter/material.dart';
import 'package:project/models/nutrition_data.dart';

class AnalyticsCaloriesRecommendations extends StatelessWidget {
  final NutritionData nutritionData;

  const AnalyticsCaloriesRecommendations({
    super.key,
    required this.nutritionData,
  });

  @override
  Widget build(BuildContext context) {
    final caloriesLeft = nutritionData.caloriesLeft;
    
    String message;
    Color backgroundColor;
    Color borderColor;
    
    if (caloriesLeft > 500) {
      message = 'You can eat ${caloriesLeft} kcal more today to reach your goal.';
      backgroundColor = Colors.green[50]!;
      borderColor = Colors.green[200]!;
    } else if (caloriesLeft > 0) {
      message = 'You have ${caloriesLeft} kcal left today. Try to reach your goal!';
      backgroundColor = Colors.orange[50]!;
      borderColor = Colors.orange[200]!;
    } else if (caloriesLeft == 0) {
      message = 'Perfect! You\'ve reached your calorie goal for today.';
      backgroundColor = Colors.green[50]!;
      borderColor = Colors.green[200]!;
    } else {
      message = 'You\'ve exceeded your goal by ${-caloriesLeft} kcal today.';
      backgroundColor = Colors.red[50]!;
      borderColor = Colors.red[200]!;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: caloriesLeft >= 0 ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              caloriesLeft >= 0 ? Icons.lightbulb_outline : Icons.warning_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  caloriesLeft >= 0 ? 'Calorie Recommendation' : 'Calorie Alert',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}