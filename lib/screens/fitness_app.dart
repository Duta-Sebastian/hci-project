import 'package:flutter/material.dart';
import '../models/nutrition_data.dart';
import '../utils/date_utils.dart';
import '../widgets/add_entry_modal.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'analytics_screen.dart';
import 'community_screen.dart';
import 'account_screen.dart';

class FitnessApp extends StatefulWidget {
  const FitnessApp({super.key});

  @override
  FitnessAppState createState() => FitnessAppState();
}

class FitnessAppState extends State<FitnessApp> {
  int _selectedIndex = 0;
  late PageController _pageController;

  // User stats
  final String userName = "Maria";
  final int streakDays = 5;
  
  // Nutrition goals and current values
  late NutritionData nutritionData;

  // Date info
  late DateTime _selectedDate;
  late DateTime _monthStart;
  late List<DateTime> _weekDays;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _selectedDate = DateTime.now();
    _monthStart = DateUtil.getMonthStart(_selectedDate);
    _weekDays = DateUtil.generateWeekDays(_selectedDate);
    nutritionData = NutritionData.defaultGoals();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    // Here you would load data for the selected date
  }

  void _onMonthChanged(DateTime month) {
    setState(() {
      _monthStart = DateUtil.getMonthStart(month);
    });
    // Here you would load data for the selected month
  }

  void _showAddEntryModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddEntryModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            HomeScreen(
              userName: userName,
              streakDays: streakDays,
              nutritionData: nutritionData,
              selectedDate: _selectedDate,
              monthStart: _monthStart,
              weekDays: _weekDays,
              onDateSelected: _onDateSelected,
              onMonthChanged: _onMonthChanged,
            ),
            const AnalyticsScreen(),
            const CommunityScreen(),
            const AccountScreen(),
          ],
        ),
      ),
      // Bottom navigation bar with FAB
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEntryModal,
        backgroundColor: Colors.purple.shade300,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}