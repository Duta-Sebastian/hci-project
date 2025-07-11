import 'package:flutter/material.dart';
import 'package:project/screens/entry-screens/height_screen.dart';
import 'package:project/widgets/entry_screens/custom_button.dart';

class ActivityLevelScreen extends StatefulWidget {
  final String gender;
  final int age;
  
  const ActivityLevelScreen({
    super.key, 
    required this.gender, 
    required this.age,
  });

  @override
  State<ActivityLevelScreen> createState() => _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends State<ActivityLevelScreen> {
  String selectedActivityLevel = 'Lightly active';
  
  final List<String> activityLevels = [
    'Sedentary',
    'Lightly active',
    'Moderately active',
    'Very active',
    'Extra active'
  ];

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
                'What is your activity level?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: activityLevels.map((level) {
                  return _buildActivityLevelTile(level);
                }).toList(),
              ),
              const Spacer(),
              CustomButton(
                text: 'Continue',
                isPrimary: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HeightScreen(
                        gender: widget.gender,
                        age: widget.age,
                        activityLevel: selectedActivityLevel,
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

  Widget _buildActivityLevelTile(String level) {
    final isSelected = selectedActivityLevel == level;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedActivityLevel = level;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB3FF65),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getActivityIcon(level),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      level,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
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
  
  IconData _getActivityIcon(String level) {
    switch (level) {
      case 'Sedentary':
        return Icons.weekend;
      case 'Lightly active':
        return Icons.directions_walk;
      case 'Moderately active':
        return Icons.directions_run;
      case 'Very active':
        return Icons.fitness_center;
      case 'Extra active':
        return Icons.sports_handball;
      default:
        return Icons.directions_walk;
    }
  }
}