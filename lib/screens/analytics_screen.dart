// lib/screens/analytics_screen.dart
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.bar_chart, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'Analytics Screen',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}

