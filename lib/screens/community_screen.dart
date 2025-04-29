import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.people, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'Community Screen',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}