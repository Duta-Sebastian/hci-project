// lib/screens/onboarding/weight_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import 'weight_goal_screen.dart'; // Import the new weight goal screen

class WeightScreen extends StatefulWidget {
  final String gender;
  final int age;
  final String activityLevel;
  final int height;
  
  const WeightScreen({
    Key? key, 
    required this.gender, 
    required this.age,
    required this.activityLevel,
    required this.height
  }) : super(key: key);

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  int selectedWeight = 65;

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
                'What is your weight?',
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
                          selectedWeight.toString(),
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
                      value: selectedWeight.toDouble(),
                      min: 40,
                      max: 150,
                      divisions: 110,
                      activeColor: const Color(0xFFB3FF65), // Green accent
                      inactiveColor: Colors.grey.shade300,
                      thumbColor: const Color(0xFFB3FF65), // Green thumb
                      onChanged: (double value) {
                        setState(() {
                          selectedWeight = value.round();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'Continue', // Changed from "Finish Setup" to "Continue"
                isPrimary: true, // Purple button
                onPressed: () {
                  // Navigate to the weight goal screen instead of account screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeightGoalScreen(
                        gender: widget.gender,
                        age: widget.age,
                        height: widget.height,
                        activityLevel: widget.activityLevel,
                        weight: selectedWeight,
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
}