import 'package:flutter/material.dart';
import 'package:project/screens/entry-screens/weight_goal_screen.dart';
import 'package:project/widgets/entry_screens/custom_button.dart';

class WeightScreen extends StatefulWidget {
  final String gender;
  final int age;
  final String activityLevel;
  final int height;
  
  const WeightScreen({
    super.key, 
    required this.gender, 
    required this.age,
    required this.activityLevel,
    required this.height
  });

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  int selectedWeight = 65;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6B9FF),
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
                'What is your weight?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFB3FF65)),
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
                      activeColor: const Color(0xFFB3FF65),
                      inactiveColor: Colors.grey.shade300,
                      thumbColor: const Color(0xFFB3FF65),
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
                text: 'Continue',
                isPrimary: true,
                onPressed: () {
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