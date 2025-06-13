import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFB6FF66),
                shape: BoxShape.circle
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.restaurant_menu,
                  color: Colors.white,
                  size: 30,
                ),
                Container(
                  width: 2,
                  height: 30,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                ),
                const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'SMART',
                style: TextStyle(
                  color: Color(0xFFD9A8FF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'BITE',
                style: TextStyle(
                  color: Color(0xFFB6FF66),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}