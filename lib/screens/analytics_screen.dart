import 'package:flutter/material.dart';
import 'package:project/models/nutrition_data.dart';
import '../widgets/analytics_tab_selector.dart';
import '../widgets/analytics_calories_content.dart';

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
  int selectedTabIndex = 1; // CALORIES tab selected by default

  final List<String> tabs = ['WEIGHT', 'CALORIES', 'MACROS', 'STREAK'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Analytics',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Tab Selector
          AnalyticsTabSelector(
            tabs: tabs,
            selectedIndex: selectedTabIndex,
            onTabSelected: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
          ),
          
          // Content based on selected tab
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0: // WEIGHT
        return const _ComingSoonContent(title: 'Weight Analytics');
      case 1: // CALORIES
        return AnalyticsCaloriesContent(
          nutritionData: widget.nutritionData,
          selectedDate: widget.selectedDate,
        );
      case 2: // MACROS
        return const _ComingSoonContent(title: 'Macros Analytics');
      case 3: // STREAK
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
