import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.settings, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'Account Screen',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}