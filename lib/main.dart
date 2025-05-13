// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/fitness_app.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'services/meal_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'meals.db');
  await deleteDatabase(path);
  
  final db = MealDatabase.instance;
  await db.addSampleData(DateTime.now());
  
  final yesterday = DateTime.now().subtract(const Duration(days: 1));
  await db.addSampleData(yesterday);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FitnessApp(),
    );
  }
}