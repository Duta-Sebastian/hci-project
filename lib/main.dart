// lib/main.dart
import 'package:flutter/material.dart';
import 'package:project/screens/fitness_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'services/meal_database.dart';
import 'screens/entry-screens/welcome_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isFirstTime = prefs.getBool('isFirstTime') ?? true;
  
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'meals.db');
  await deleteDatabase(path);
  
  final db = MealDatabase.instance;
  await db.addSampleData(DateTime.now());
  
  final yesterday = DateTime.now().subtract(const Duration(days: 1));
  await db.addSampleData(yesterday);

  if (!isFirstTime) {
    await db.getUser();  
  }
  
  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  const MyApp({
    super.key,
    required this.isFirstTime,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE6B9FF),
          secondary: const Color(0xFFB6FF66),
        ),
      ),
      
      home: isFirstTime ? WelcomeScreen() : const FitnessApp(), 
    );
  }
}