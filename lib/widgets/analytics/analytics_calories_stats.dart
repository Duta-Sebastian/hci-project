import 'package:flutter/material.dart';
import 'package:project/models/nutrition_data.dart';

class AnalyticsCaloriesStats extends StatelessWidget {
  final NutritionData nutritionData;
  final int periodIndex;

  const AnalyticsCaloriesStats({
    super.key,
    required this.nutritionData,
    required this.periodIndex,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> stats = _getStatsForPeriod(periodIndex);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Daily Goal', '${stats['dailyGoal']} kcal'),
              _buildStatItem('Consumed Today', '${stats['consumed']} kcal'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildColoredStat(
                '${stats['carbsPercent']}%', 
                'Carbs (${nutritionData.goals['Carbs']!.current}g)', 
                Colors.purple[300]!
              ),
              const SizedBox(width: 24),
              _buildColoredStat(
                '${stats['proteinPercent']}%', 
                'Protein (${nutritionData.goals['Protein']!.current}g)', 
                Colors.purple[200]!
              ),
              const SizedBox(width: 24),
              _buildColoredStat(
                '${stats['fatPercent']}%', 
                'Fat (${nutritionData.goals['Fat']!.current}g)', 
                Colors.purple[100]!
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildColoredStat(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatsForPeriod(int periodIndex) {
    final carbsGoal = nutritionData.goals['Carbs']!;
    final proteinGoal = nutritionData.goals['Protein']!;
    final fatGoal = nutritionData.goals['Fat']!;
    
    final carbsPercent = carbsGoal.target > 0 
        ? ((carbsGoal.current / carbsGoal.target) * 100).round()
        : 0;
    final proteinPercent = proteinGoal.target > 0 
        ? ((proteinGoal.current / proteinGoal.target) * 100).round()
        : 0;
    final fatPercent = fatGoal.target > 0 
        ? ((fatGoal.current / fatGoal.target) * 100).round()
        : 0;
    
    return {
      'dailyGoal': nutritionData.totalCalories,
      'consumed': nutritionData.consumedCalories,
      'carbsPercent': carbsPercent,
      'proteinPercent': proteinPercent,
      'fatPercent': fatPercent,
    };
  }
}

