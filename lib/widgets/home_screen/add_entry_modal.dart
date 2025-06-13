import 'package:flutter/material.dart';

class AddEntryModal extends StatelessWidget {
  const AddEntryModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add Entry',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAddOption(context, Icons.restaurant, 'Food'),
              _buildAddOption(context, Icons.fitness_center, 'Exercise'),
              _buildAddOption(context, Icons.local_drink, 'Water'),
              _buildAddOption(context, Icons.monitor_weight, 'Weight'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddOption(BuildContext context, IconData icon, String label) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        // Here you would navigate to the specific add screen
        // For example, food logging, exercise tracking, etc.
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.purple),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}