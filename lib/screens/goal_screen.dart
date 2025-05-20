// lib/screens/goal_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'gender_screen.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({Key? key}) : super(key: key);

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  String selectedGoal = '';

  final List<Map<String, dynamic>> goals = [
    {
      'label': 'Lose weight',
      'icon': Icons.trending_down,
      'value': 'lose_weight'
    },
    {
      'label': 'Gain weight',
      'icon': Icons.trending_up,
      'value': 'gain_weight'
    },
    {
      'label': 'Maintain your weight',
      'icon': Icons.balance,
      'value': 'maintain_weight'
    },
  ];

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
                'What is your main goal?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: goals.map((goal) => _buildGoalTile(
                  goal['label'],
                  goal['icon'],
                  goal['value'],
                )).toList(),
              ),
              const Spacer(),
              CustomButton(
                text: 'Continue',
                isPrimary: true,
                onPressed: selectedGoal.isEmpty 
                    ? null 
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GenderScreen(),
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

  Widget _buildGoalTile(String label, IconData iconData, String value) {
    final isSelected = selectedGoal == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGoal = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFB3FF65),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Icon(
                  iconData,
                  color: Colors.white,
                ),
              ),
              title: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            
            // Only show green checkmark when selected
            if (isSelected)
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFB3FF65),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}