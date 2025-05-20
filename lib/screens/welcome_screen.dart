// lib/screens/welcome_screen.dart
import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/logo.dart'; 
import '../widgets/custom_button.dart';
import 'signup_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                const Logo(), // Updated class name
                const Spacer(flex: 2),
                CustomButton(
                  text: 'Create an account',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
                ),
                CustomButton(
                  text: 'Log into account',
                  isPrimary: false,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}