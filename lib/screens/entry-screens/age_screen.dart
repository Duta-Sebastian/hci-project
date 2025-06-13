import 'package:flutter/material.dart';
import 'package:project/screens/entry-screens/activity_level_screen.dart';
import 'package:project/widgets/entry_screens/custom_button.dart';


class AgeScreen extends StatefulWidget {
  final String gender;
  
  const AgeScreen({super.key, required this.gender});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  int selectedAge = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6B9FF), 
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6B9FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                'What is your age?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            if (selectedAge > 12) {
                              setState(() {
                                selectedAge--;
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 20),
                        Text(
                          selectedAge.toString(),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            if (selectedAge < 100) {
                              setState(() {
                                selectedAge++;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    Slider(
                      value: selectedAge.toDouble(),
                      min: 12,
                      max: 100,
                      divisions: 88,
                      activeColor: const Color.fromARGB(255, 247, 249, 248),
                      onChanged: (double value) {
                        setState(() {
                          selectedAge = value.round();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivityLevelScreen(
                        gender: widget.gender,
                        age: selectedAge,
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