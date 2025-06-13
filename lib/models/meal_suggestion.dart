class MealSuggestion {
  final String name;
  final int calories;
  final String weight;
  final String protein;
  final String fat;
  final String carbs;
  final String image;
  final List<String> ingredients;
  final List<String> preparation;
  final List<String> tags;

  MealSuggestion({
    required this.name,
    required this.calories,
    required this.weight,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.image,
    required this.ingredients,
    required this.preparation,
    required this.tags,
  });
}