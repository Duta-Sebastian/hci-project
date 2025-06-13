import 'package:flutter/material.dart';
import 'package:project/models/nutrition_data.dart';
import 'package:project/widgets/analytics/analytics_calories_content.dart';
import 'package:project/widgets/analytics/analytics_tab_selector.dart';

class AnalyticsScreen extends StatefulWidget {
  final NutritionData nutritionData;
  final DateTime selectedDate;

  const AnalyticsScreen({
    super.key,
    required this.nutritionData,
    required this.selectedDate,
  });

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int selectedTabIndex = 1;

  final List<String> tabs = ['WEIGHT', 'CALORIES', 'MACROS', 'STREAK'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Analytics',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          AnalyticsTabSelector(
            tabs: tabs,
            selectedIndex: selectedTabIndex,
            onTabSelected: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
          ),
          
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return const _ComingSoonContent(title: 'Weight Analytics');
      case 1:
        return AnalyticsCaloriesContent(
          nutritionData: widget.nutritionData,
          selectedDate: widget.selectedDate,
        );
      case 2:
        return const _ComingSoonContent(title: 'Macros Analytics');
      case 3:
        return const _ComingSoonContent(title: 'Streak Analytics');
      default:
        return AnalyticsCaloriesContent(
          nutritionData: widget.nutritionData,
          selectedDate: widget.selectedDate,
        );
    }
  }
}

class _ComingSoonContent extends StatelessWidget {
  final String title;
  
  const _ComingSoonContent({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
