// lib/screens/onboarding/weight_goal_screen.dart
import 'package:flutter/material.dart';
import 'package:project/models/user_model.dart';
import 'package:project/screens/entry-screens/plan_summary_screen.dart';
import 'package:project/widgets/custom_button.dart';

class WeightGoalScreen extends StatefulWidget {
  final String gender;
  final int age;
  final String activityLevel;
  final int height;
  final int weight;
  
  const WeightGoalScreen({
    super.key, 
    required this.gender, 
    required this.age,
    required this.activityLevel,
    required this.height,
    required this.weight,
  });

  @override
  State<WeightGoalScreen> createState() => _WeightGoalScreenState();
}

class _WeightGoalScreenState extends State<WeightGoalScreen> {
  late int selectedWeightGoal;
  
  @override
  void initState() {
    super.initState();
    // Initialize weight goal to current weight as a starting point
    selectedWeightGoal = widget.weight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6B9FF), // Purple background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White icon
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
                'What is your weight goal?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFB3FF65)), // Green border
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedWeightGoal.toString(),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'kg',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Slider(
                      value: selectedWeightGoal.toDouble(),
                      min: 40,
                      max: 150,
                      divisions: 110,
                      activeColor: const Color(0xFFB3FF65), // Green accent
                      inactiveColor: Colors.grey.shade300,
                      thumbColor: const Color(0xFFB3FF65), // Green thumb
                      onChanged: (double value) {
                        setState(() {
                          selectedWeightGoal = value.round();
                        });
                      },
                    ),
                    
                    // Optional indicator showing relation to current weight
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        _getWeightGoalText(),
                        style: TextStyle(
                          fontSize: 14,
                          color: _getWeightGoalColor(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'Continue',
                isPrimary: true, // Primary button
                onPressed: () {
                  // Update user model with all collected data
                  UserModel.updateUserDetails(
                    widget.gender,
                    widget.age,
                    widget.height,
                    widget.weight,
                    widget.activityLevel,
                  );
                  
                  // Save the weight goal
                  UserModel.setWeightGoal(selectedWeightGoal);
                  
                  // Determine main goal based on weight vs weight goal
                  String mainGoal = "Maintain weight";
                  if (selectedWeightGoal < widget.weight) {
                    mainGoal = "Lose weight";
                  } else if (selectedWeightGoal > widget.weight) {
                    mainGoal = "Gain weight";
                  }
                  
                  // Save the main goal
                  UserModel.setGoal(mainGoal);
                  
                  // Navigate to plan summary screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlanSummaryScreen(
                        gender: widget.gender,
                        age: widget.age,
                        height: widget.height,
                        weight: widget.weight,
                        activityLevel: widget.activityLevel,
                        weightGoal: selectedWeightGoal,
                        mainGoal: mainGoal,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to show text based on goal compared to current weight
  String _getWeightGoalText() {
    final difference = selectedWeightGoal - widget.weight;
    
    if (difference > 0) {
      return 'Gain ${difference.abs()} kg';
    } else if (difference < 0) {
      return 'Lose ${difference.abs()} kg';
    } else {
      return 'Maintain current weight';
    }
  }
  
  // Helper method to get color based on goal
  Color _getWeightGoalColor() {
    final difference = selectedWeightGoal - widget.weight;
    
    if (difference > 0) {
      return Colors.blue;
    } else if (difference < 0) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}