import 'package:flutter/material.dart';
import 'package:project/screens/entry-screens/weight_screen.dart';
import 'package:project/widgets/entry_screens/custom_button.dart';

class HeightScreen extends StatefulWidget {
  final String gender;
  final int age;
  final String activityLevel;
  
  const HeightScreen({
    super.key, 
    required this.gender, 
    required this.age,
    required this.activityLevel,
  });

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  int selectedHeight = 165;

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
                'What is your height?',
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
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedHeight.toString(),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'cm',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Slider(
                      value: selectedHeight.toDouble(),
                      min: 120,
                      max: 220,
                      divisions: 100,
                      activeColor: const Color(0xFFB3FF65),
                      inactiveColor: Colors.grey.shade300,
                      thumbColor: const Color(0xFFB3FF65),
                      onChanged: (double value) {
                        setState(() {
                          selectedHeight = value.round();
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
                      builder: (context) => WeightScreen(
                        gender: widget.gender,
                        age: widget.age,
                        activityLevel: widget.activityLevel,
                        height: selectedHeight,
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