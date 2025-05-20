// lib/screens/gender_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'entry-screens/age_screen.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String selectedGender = '';

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions to make responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'What is your gender?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            // Main content centered in the middle of the screen
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGenderCard('Female', 'female', screenWidth, screenHeight),
                    SizedBox(width: screenWidth * 0.05), // Responsive spacing
                    _buildGenderCard('Male', 'male', screenWidth, screenHeight),
                  ],
                ),
              ),
            ),
            
            // Continue button at bottom
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                text: 'Continue',
                isPrimary: true,
                onPressed: selectedGender.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AgeScreen(gender: selectedGender),
                          ),
                        );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderCard(String label, String value, double screenWidth, double screenHeight) {
    final isSelected = selectedGender == value;
    
    // Calculate card size based on screen dimensions
    final cardWidth = screenWidth * 0.42; // 42% of screen width
    final cardHeight = screenHeight * 0.27; // 27% of screen height
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = value;
        });
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20, // Even larger text
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: cardWidth * 0.75, // 75% of card width
                  height: cardHeight * 0.5, // 50% of card height
                  decoration: BoxDecoration(
                    color: const Color(0xFFB3FF65),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Icon(
                      value == 'female' ? Icons.female : Icons.male,
                      color: Colors.white,
                      size: cardWidth * 0.3, // 30% of card width
                    ),
                  ),
                ),
              ],
            ),
            
            if (isSelected)
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color(0xFFB3FF65),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24, // Larger checkmark
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}