
import 'package:project/models/nutrient_goal.dart';

class NutritionData {
  final int totalCalories;
  final int consumedCalories;
  final Map<String, NutrientGoal> goals;

  NutritionData({
    required this.totalCalories,
    required this.consumedCalories,
    required this.goals,
  });

  int get caloriesLeft => totalCalories - consumedCalories;
  
  // Factory constructor to create a default nutrition data object
  factory NutritionData.defaultGoals() {
    return NutritionData(
      totalCalories: 2300,
      consumedCalories: 452,
      goals: {
        'Carbs': NutrientGoal(target: 232, current: 135, unit: 'g'),
        'Protein': NutrientGoal(target: 280, current: 202, unit: 'g'),
        'Fat': NutrientGoal(target: 110, current: 90, unit: 'g'),
      },
    );
  }
}