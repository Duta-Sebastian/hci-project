// lib/providers/meal_provider.dart
import 'package:flutter/foundation.dart';
import 'package:project/models/meal.dart';
import 'package:project/services/meal_database.dart';

class MealProvider with ChangeNotifier {
  final MealDatabase _database = MealDatabase.instance;
  DateTime _selectedDate = DateTime.now();
  
  // Store meals by type for the selected date
  Map<String, List<Meal>> _mealsByType = {
    'breakfast': [],
    'lunch': [],
    'dinner': [],
  };
  
  // Getters
  DateTime get selectedDate => _selectedDate;
  Map<String, List<Meal>> get mealsByType => _mealsByType;
  
  // Calculate total calories for a meal type
  int getTotalCaloriesForType(String mealType) {
    if (!_mealsByType.containsKey(mealType)) return 0;
    
    return _mealsByType[mealType]!.fold(
      0, (sum, meal) => sum + meal.calories
    );
  }
  
  // Calculate total nutrients for a meal type
  Map<String, double> getTotalNutrientsForType(String mealType) {
    if (!_mealsByType.containsKey(mealType)) {
      return {'carbs': 0, 'protein': 0, 'fat': 0};
    }
    
    var result = {'carbs': 0.0, 'protein': 0.0, 'fat': 0.0};
    
    for (var meal in _mealsByType[mealType]!) {
      result['carbs'] = (result['carbs'] ?? 0) + (meal.nutrients['carbs'] ?? 0);
      result['protein'] = (result['protein'] ?? 0) + (meal.nutrients['protein'] ?? 0);
      result['fat'] = (result['fat'] ?? 0) + (meal.nutrients['fat'] ?? 0);
    }
    
    return result;
  }
  
  // Set selected date and load meals
  Future<void> setSelectedDate(DateTime date) async {
    _selectedDate = date;
    await loadMeals();
    notifyListeners();
  }
  
  // Load meals for the selected date
  Future<void> loadMeals() async {
    // Reset meals
    _mealsByType = {
      'breakfast': [],
      'lunch': [],
      'dinner': [],
    };
    
    // Get all meals for the selected date
    final meals = await _database.getMealsByDate(_selectedDate);
    
    // Group meals by type
    for (var meal in meals) {
      if (_mealsByType.containsKey(meal.mealType)) {
        _mealsByType[meal.mealType]!.add(meal);
      }
    }
    
    notifyListeners();
  }
  
  // Add a new meal
  Future<void> addMeal(Meal meal) async {
    await _database.addMeal(meal);
    await loadMeals();  // Reload meals after adding
  }
  
  // Delete a meal
  Future<void> deleteMeal(int id) async {
    await _database.deleteMeal(id);
    await loadMeals();  // Reload meals after deleting
  }
  
  // Add sample data for testing
  Future<void> addSampleData() async {
    final todayBreakfast = [
      Meal(
        name: 'Eggs (3 pieces)',
        calories: 150,
        nutrients: {'carbs': 1.4, 'protein': 3.5, 'fat': 14.5},
        mealType: 'breakfast',
        date: DateTime.now(),
      ),
      Meal(
        name: 'Bread (1 piece)',
        calories: 250,
        nutrients: {'carbs': 3.5, 'protein': 1.5, 'fat': 10.0},
        mealType: 'breakfast',
        date: DateTime.now(),
      ),
      Meal(
        name: 'Tomato (80g)',
        calories: 90,
        nutrients: {'carbs': 5.0, 'protein': 0.5, 'fat': 5.45},
        mealType: 'breakfast',
        date: DateTime.now(),
      ),
    ];
    
    final todayLunch = [
      Meal(
        name: 'Chicken Salad',
        calories: 450,
        nutrients: {'carbs': 10.0, 'protein': 35.0, 'fat': 20.0},
        mealType: 'lunch',
        date: DateTime.now(),
      ),
      Meal(
        name: 'Brown Rice (100g)',
        calories: 350,
        nutrients: {'carbs': 45.0, 'protein': 5.0, 'fat': 2.0},
        mealType: 'lunch',
        date: DateTime.now(),
      ),
    ];
    
    // Add sample breakfast meals
    for (var meal in todayBreakfast) {
      await _database.addMeal(meal);
    }
    
    // Add sample lunch meals
    for (var meal in todayLunch) {
      await _database.addMeal(meal);
    }
    
    await loadMeals();  // Reload after adding sample data
  }
}