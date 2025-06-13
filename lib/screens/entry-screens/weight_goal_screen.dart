import 'package:flutter/material.dart';
import 'package:project/models/user_model.dart';
import 'package:project/screens/entry-screens/plan_summary_screen.dart';
import 'package:project/widgets/entry_screens/custom_button.dart';

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
    selectedWeightGoal = widget.weight;
  }

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
                'What is your weight goal?',
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
                      activeColor: const Color(0xFFB3FF65),
                      inactiveColor: Colors.grey.shade300,
                      thumbColor: const Color(0xFFB3FF65),
                      onChanged: (double value) {
                        setState(() {
                          selectedWeightGoal = value.round();
                        });
                      },
                    ),
                    
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
                isPrimary: true,
                onPressed: () {
                  UserModel.updateUserDetails(
                    widget.gender,
                    widget.age,
                    widget.height,
                    widget.weight,
                    widget.activityLevel,
                  );

                  UserModel.setWeightGoal(selectedWeightGoal);
                  
                  String mainGoal = "Maintain weight";
                  if (selectedWeightGoal < widget.weight) {
                    mainGoal = "Lose weight";
                  } else if (selectedWeightGoal > widget.weight) {
                    mainGoal = "Gain weight";
                  }
                  
                  UserModel.setGoal(mainGoal);
                  
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