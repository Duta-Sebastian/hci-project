import 'package:flutter/material.dart';
import 'package:project/models/nutrition_data.dart';

class AnalyticsCaloriesBreakdown extends StatelessWidget {
  final NutritionData nutritionData;
  final int periodIndex;

  const AnalyticsCaloriesBreakdown({
    super.key,
    required this.nutritionData,
    required this.periodIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (periodIndex == 0) {
      // Day view - show consumed vs remaining
      return _buildDayBreakdown();
    } else if (periodIndex == 1) {
      // Week view - show meal breakdown like Figma
      return _buildWeekMealBreakdown();
    } else {
      // Month view - show macronutrient breakdown
      return _buildMacroBreakdown();
    }
  }

  Widget _buildDayBreakdown() {
    final totalCalories = nutritionData.totalCalories;
    final consumedCalories = nutritionData.consumedCalories;
    final caloriesLeft = nutritionData.caloriesLeft;
    
    final consumedPercentage = totalCalories > 0 
        ? ((consumedCalories / totalCalories) * 100).round()
        : 0;
    final leftPercentage = totalCalories > 0 
        ? ((caloriesLeft / totalCalories) * 100).round()
        : 0;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBreakdownItem(
          '$consumedPercentage%', 
          'Consumed\n($consumedCalories kcal)', 
          Colors.purple[300]!
        ),
        _buildBreakdownItem(
          '$leftPercentage%', 
          'Remaining\n($caloriesLeft kcal)', 
          Colors.purple[50]!
        ),
      ],
    );
  }

  Widget _buildWeekMealBreakdown() {
    return Column(
      children: [
        // Center number like in Figma
        Text(
          '${(nutritionData.totalCalories * 1.08).round()}',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          'kcal',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Breakdown percentages like Figma
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMealBreakdownItem('20%', 'Breakfast', Colors.purple[300]!),
            _buildMealBreakdownItem('35%', 'Lunch', Colors.purple[200]!),
            _buildMealBreakdownItem('45%', 'Dinner', Colors.purple[100]!),
            _buildMealBreakdownItem('0%', 'Other', Colors.grey[300]!),
          ],
        ),
      ],
    );
  }

  Widget _buildMacroBreakdown() {
    final carbsGoal = nutritionData.goals['Carbs']!;
    final proteinGoal = nutritionData.goals['Protein']!;
    final fatGoal = nutritionData.goals['Fat']!;
    
    return Row(
      children: [
        _buildBreakdownItem(
          '${carbsGoal.current}g', 
          'Carbs\n(${carbsGoal.target}g goal)', 
          Colors.purple[300]!
        ),
        const SizedBox(width: 20),
        _buildBreakdownItem(
          '${proteinGoal.current}g', 
          'Protein\n(${proteinGoal.target}g goal)', 
          Colors.purple[200]!
        ),
        const SizedBox(width: 20),
        _buildBreakdownItem(
          '${fatGoal.current}g', 
          'Fat\n(${fatGoal.target}g goal)', 
          Colors.purple[100]!
        ),
      ],
    );
  }

  Widget _buildBreakdownItem(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealBreakdownItem(String percentage, String meal, Color color) {
    return Column(
      children: [
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          meal,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}