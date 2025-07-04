import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:project/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import '../models/meal.dart';

class MealDatabase {
  static final MealDatabase instance = MealDatabase._init();
  static Database? _database;

  MealDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('meals.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE meals(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      calories INTEGER NOT NULL,
      carbs REAL NOT NULL,
      protein REAL NOT NULL,
      fat REAL NOT NULL,
      mealType TEXT NOT NULL,
      date TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      age INTEGER NOT NULL,
      height INTEGER NOT NULL,
      weight INTEGER NOT NULL,
      weightGoal INTEGER NOT NULL,
      activityLevel TEXT NOT NULL,
      gender TEXT NOT NULL
      )
    ''');
  }

  Future<int> addUser() async {
    final db = await database;
    
    Map<String, dynamic> userData = {
      'name': UserModel.name,
      'email': UserModel.email,
      'age': UserModel.age,
      'height': UserModel.height,
      'weight': UserModel.weight,
      'weightGoal': UserModel.weightGoal,
      'activityLevel': UserModel.activityLevel,
      'gender': UserModel.gender
    };
    
    return await db.insert('users', userData);
  }

  Future<int> addMeal(Meal meal) async {
    final db = await database;
    return await db.insert('meals', meal.toJson());
  }

  Future<List<int>> addMeals(List<Meal> meals) async {
    final db = await database;
    final List<int> results = [];
    
    await db.transaction((txn) async {
      for (final meal in meals) {
        final id = await txn.insert('meals', meal.toJson());
        results.add(id);
      }
    });
    
    return results;
  }

  Future<List<int>> addMultipleMeals(Meal baseMeal, int quantity) async {
    final db = await database;
    final List<int> results = [];
    
    await db.transaction((txn) async {
      final mealData = baseMeal.toJson();
      for (int i = 0; i < quantity; i++) {
        final id = await txn.insert('meals', mealData);
        results.add(id);
      }
    });
    
    return results;
  }
  
  Future<List<Meal>> getMealsByDate(DateTime date) async {
    final db = await database;
    
    final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    
    final result = await db.query(
      'meals',
      where: "date LIKE ?",
      whereArgs: ['$dateString%'],
    );

    return result.map((json) => Meal.fromJson(json)).toList();
  }

  Future<List<Meal>> getMealsByTypeAndDate(String mealType, DateTime date) async {
    final db = await database;
    
    final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    
    final result = await db.query(
      'meals',
      where: "mealType = ? AND date LIKE ?",
      whereArgs: [mealType, '$dateString%'],
    );

    return result.map((json) => Meal.fromJson(json)).toList();
  }

  Future<Map<String, List<Meal>>> getMealsGroupedByTypeForDate(DateTime date) async {
    final meals = await getMealsByDate(date);
    
    final Map<String, List<Meal>> groupedMeals = {
      'breakfast': [],
      'lunch': [],
      'dinner': [],
    };
    
    for (var meal in meals) {
      if (groupedMeals.containsKey(meal.mealType)) {
        groupedMeals[meal.mealType]!.add(meal);
      }
    }
    
    return groupedMeals;
  }

  Future<Map<String, dynamic>> calculateNutritionTotalsForDate(DateTime date) async {
    final meals = await getMealsByDate(date);
    debugPrint('Meals for date $date: ${meals.length}');
    int totalCalories = 0;
    double totalCarbs = 0;
    double totalProtein = 0;
    double totalFat = 0;
    
    for (var meal in meals) {
      totalCalories += meal.calories;
      totalCarbs += meal.nutrients['carbs'] ?? 0;
      totalProtein += meal.nutrients['protein'] ?? 0;
      totalFat += meal.nutrients['fat'] ?? 0;
    }
    
    return {
      'calories': totalCalories,
      'carbs': totalCarbs,
      'protein': totalProtein,
      'fat': totalFat,
    };
  }

  Future<int> deleteMeal(int id) async {
    final db = await database;
    return await db.delete(
      'meals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMeals(List<int> ids) async {
    final db = await database;
    int deletedCount = 0;
    
    await db.transaction((txn) async {
      for (final id in ids) {
        deletedCount += await txn.delete(
          'meals',
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    });
    
    return deletedCount;
  }

  Future<void> addSampleData(DateTime date) async {
    final breakfast = [
      Meal(
        name: 'Eggs',
        calories: 150,
        nutrients: {'carbs': 1.4, 'protein': 3.5, 'fat': 14.5},
        mealType: 'breakfast',
        date: date,
      ),
      Meal(
        name: 'Bread',
        calories: 250,
        nutrients: {'carbs': 3.5, 'protein': 1.5, 'fat': 10.0},
        mealType: 'breakfast',
        date: date,
      ),
      Meal(
        name: 'Tomato',
        calories: 90,
        nutrients: {'carbs': 5.0, 'protein': 0.5, 'fat': 5.45},
        mealType: 'breakfast',
        date: date,
      ),
    ];
    
    final lunch = [
      Meal(
        name: 'Chicken Sandwich',
        calories: 450,
        nutrients: {'carbs': 45.0, 'protein': 30.0, 'fat': 15.0},
        mealType: 'lunch',
        date: date,
      ),
    ];
    
    await addMeals([...breakfast, ...lunch]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<bool> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    
    if (maps.isNotEmpty) {
      final userData = maps.first;
      
      UserModel.name = userData['name'];
      UserModel.email = userData['email'];
      UserModel.age = userData['age'];
      UserModel.height = userData['height'];
      UserModel.weight = userData['weight'];
      UserModel.weightGoal = userData['weightGoal'];
      UserModel.activityLevel = userData['activityLevel'];
      UserModel.gender = userData['gender'];
      
      return true;
    }
    
    return false;
  }
}