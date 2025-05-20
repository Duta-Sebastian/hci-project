import 'package:project/models/nutrient_goal.dart';
import 'package:project/models/user_model.dart';

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
    // Calculate activity coefficient
    double activityCoefficient = 1;
    switch (UserModel.activityLevel) {
      case 'Sedentary':
        activityCoefficient = 1.2;
        break;
      case 'Lightly active':
        activityCoefficient = 1.375;
        break;
      case 'Moderately active':
        activityCoefficient = 1.55;
        break;
      case 'Very active':
        activityCoefficient = 1.725;
        break;
      case 'Extra active':
        activityCoefficient = 1.9;
        break;
    }
    
    // Calculate BMR using Mifflin-St Jeor equation
    double bmr = UserModel.weight * 10 + 6.25 * UserModel.height - 5 * UserModel.age + 
                (UserModel.gender == 'male' ? 5 : -161);
    
    // Calculate TDEE (Total Daily Energy Expenditure)
    double tdee = bmr * activityCoefficient;
    
    // Adjust calories based on goal
    int totalCalories;
    if (UserModel.goal == 'lose') {
      // For weight loss, create a deficit
      totalCalories = (tdee - 500).toInt();
    } else if (UserModel.goal == 'gain') {
      // For weight gain, create a surplus
      totalCalories = (tdee + 500).toInt();
    } else {
      // For maintenance, use TDEE directly
      totalCalories = tdee.toInt();
    }
    
    // Default macronutrient distribution
    double proteinRatio;
    double fatRatio;
    double carbsRatio;
    
    // Adjust macronutrient distribution based on goal
    if (UserModel.goal == 'lose') {
      // Higher protein, moderate fat, lower carbs for weight loss
      proteinRatio = 0.35;
      fatRatio = 0.30;
      carbsRatio = 0.35;
    } else if (UserModel.goal == 'gain') {
      // Higher carbs, moderate protein, moderate fat for weight gain
      proteinRatio = 0.25;
      fatRatio = 0.25;
      carbsRatio = 0.50;
    } else {
      // Balanced macros for maintenance
      proteinRatio = 0.30;
      fatRatio = 0.25;
      carbsRatio = 0.45;
    }
    
    // Calculate macronutrient targets in grams
    // Protein: 4 calories per gram
    // Carbs: 4 calories per gram
    // Fat: 9 calories per gram
    int proteinTarget = ((totalCalories * proteinRatio) / 4).round();
    int carbsTarget = ((totalCalories * carbsRatio) / 4).round();
    int fatTarget = ((totalCalories * fatRatio) / 9).round();
    
    return NutritionData(
      totalCalories: totalCalories,
      consumedCalories: 0, // Start with 0 consumed calories
      goals: {
        'Carbs': NutrientGoal(target: carbsTarget, current: 0, unit: 'g'),
        'Protein': NutrientGoal(target: proteinTarget, current: 0, unit: 'g'),
        'Fat': NutrientGoal(target: fatTarget, current: 0, unit: 'g'),
      },
    );
  }
}