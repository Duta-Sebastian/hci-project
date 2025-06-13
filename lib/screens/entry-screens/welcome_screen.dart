import 'package:flutter/material.dart';
import 'package:project/screens/entry-screens/login_screen.dart';
import 'package:project/screens/entry-screens/signup_screen.dart';
import 'package:project/widgets/entry_screens/custom_button.dart';
import 'package:project/widgets/entry_screens/gradient_background.dart';
import 'package:project/widgets/entry_screens/logo.dart';


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
                const Logo(),
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