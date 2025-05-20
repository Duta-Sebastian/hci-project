// lib/screens/onboarding/plan_summary_screen.dart
import 'package:flutter/material.dart';
import 'package:project/screens/fitness_app.dart';
import 'package:project/services/meal_database.dart';
import 'package:project/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PlanSummaryScreen extends StatelessWidget {
  final String gender;
  final int age;
  final String activityLevel;
  final int height;
  final int weight;
  final int weightGoal;
  final String mainGoal;
  
  const PlanSummaryScreen({
    super.key, 
    required this.gender, 
    required this.age,
    required this.activityLevel,
    required this.height,
    required this.weight,
    required this.weightGoal,
    required this.mainGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6B9FF), // Purple background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your plan summary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Gender and Age row
              Row(
                children: [
                  _buildInfoCard(
                    'Gender',
                    gender == "male" ? "M" : "F", // Just show first letter (F or M)
                    flex: 1,
                  ),
                  const SizedBox(width: 10),
                  _buildInfoCard(
                    'Age',
                    age.toString(),
                    flex: 1,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Main goal
              _buildInfoCard(
                'Main goal',
                mainGoal,
              ),
              const SizedBox(height: 15),
              // Activity level
              _buildInfoCard(
                'Activity level',
                activityLevel,
              ),
              const SizedBox(height: 15),
              // Height and Weight row
              Row(
                children: [
                  _buildInfoCard(
                    'Height',
                    '$height cm',
                    flex: 1,
                  ),
                  const SizedBox(width: 10),
                  _buildInfoCard(
                    'Weight',
                    '$weight kg',
                    flex: 1,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Goal weight
              _buildInfoCard(
                'Your goal weight',
                '$weightGoal kg',
              ),
              const Spacer(),
              // Final button
              CustomButton(
                text: "Let's go",
                isPrimary: true,
                onPressed: () async {
                  MealDatabase.instance.addUser();
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('isFirstTime', false);
                  // Navigate to the fitness app
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FitnessApp(),
                    ),
                    (route) => false, // Remove all previous routes
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to build consistent info cards
  Widget _buildInfoCard(String label, String value, {int flex = 0, String? subtitle}) {
    return Expanded(
      flex: flex > 0 ? flex : 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}