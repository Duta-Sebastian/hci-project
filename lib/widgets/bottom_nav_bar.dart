import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Button
            Expanded(
              child: _buildNavItem(0, Icons.home, 'Home'),
            ),
            // Analytics Button
            Expanded(
              child: _buildNavItem(1, Icons.bar_chart, 'Analytics'),
            ),
            // Empty space for FAB
            const Spacer(),
            // Community Button
            Expanded(
              child: _buildNavItem(2, Icons.people, 'Community'),
            ),
            // Account Button
            Expanded(
              child: _buildNavItem(3, Icons.settings, 'Account'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon, 
            color: isSelected ? Colors.black : Colors.grey,
          ),
          Text(
            label, 
            style: TextStyle(
              fontSize: 12, 
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}