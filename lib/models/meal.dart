// lib/models/meal.dart
class Meal {
  final int id;
  final String name;
  final int calories;
  final Map<String, double> nutrients;
  final String mealType;
  final DateTime date;

  const Meal({
    this.id = 0,
    required this.name,
    required this.calories,
    required this.nutrients,
    required this.mealType,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calories': calories,
      'carbs': nutrients['carbs'] ?? 0.0,
      'protein': nutrients['protein'] ?? 0.0,
      'fat': nutrients['fat'] ?? 0.0,
      'mealType': mealType,
      'date': date.toIso8601String(),
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as int,
      name: json['name'] as String,
      calories: json['calories'] as int,
      nutrients: {
        'carbs': json['carbs'] as double,
        'protein': json['protein'] as double,
        'fat': json['fat'] as double,
      },
      mealType: json['mealType'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}