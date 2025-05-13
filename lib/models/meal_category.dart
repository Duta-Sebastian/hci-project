import 'package:project/models/meal.dart';

class MealCategory {
  final String title;
  final int totalCalories;
  final Map<String, double> nutrients;
  final List<Meal> meals;

  const MealCategory({
    required this.title,
    required this.totalCalories,
    required this.nutrients,
    required this.meals,
  });
}