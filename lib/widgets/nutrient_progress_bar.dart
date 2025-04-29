import 'package:flutter/material.dart';

class NutrientProgressBar extends StatelessWidget {
  final String title;
  final int current;
  final int target;
  final String unit;
  final double progress;
  final Color color;

  const NutrientProgressBar({
    super.key,
    required this.title,
    required this.current,
    required this.target,
    required this.unit,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            '$current/$target$unit',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: color,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}