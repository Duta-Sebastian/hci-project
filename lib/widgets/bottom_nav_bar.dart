import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final bool isFABVisible;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.isFABVisible,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color.fromRGBO(22, 22, 22, 1),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _buildNavItem(0, Icons.home, 'Home'),
            ),
            Expanded(
              child: _buildNavItem(1, Icons.bar_chart, 'Analytics'),
            ),
            if (selectedIndex == 0 && isFABVisible) const Spacer(),
            Expanded(
              child: _buildNavItem(2, Icons.restaurant_menu, 'Suggestions'),
            ),
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
            color: isSelected ? Color.fromRGBO(181, 241, 77, 1) : Colors.white,
          ),
          Text(
            label, 
            style: TextStyle(
              fontSize: 12, 
              color: isSelected ? Color.fromRGBO(181, 241, 77, 1) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}