import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/date_utils.dart';

class WeekDaySelector extends StatefulWidget {
  final List<DateTime> weekDays;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Function(List<DateTime>) onWeekChanged;

  const WeekDaySelector({
    super.key,
    required this.weekDays,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onWeekChanged,
  });

  @override
  State<WeekDaySelector> createState() => WeekDaySelectorState();
}

class WeekDaySelectorState extends State<WeekDaySelector> {
  late PageController _pageController;
  late List<List<DateTime>> _weeks;
  int _currentPage = 0;
  
  // How many weeks to show on each side of the current week
  static const int _extraWeeks = 50;

  @override
  void initState() {
    super.initState();
    _initializeWeeks();
  }

  void _initializeWeeks() {
    // Generate a large number of weeks to allow extensive scrolling
    final DateTime now = DateTime.now();
    final DateTime startDate = now.subtract(Duration(days: 7 * _extraWeeks));
    
    _weeks = [];
    DateTime weekStart = _getWeekStartDate(startDate);
    
    // Generate weeks (current week will be at index _extraWeeks)
    for (int i = 0; i < _extraWeeks * 2; i++) {
      _weeks.add(_generateWeekDays(weekStart));
      weekStart = weekStart.add(const Duration(days: 7));
    }
    
    // Find which week contains the selected date
    bool found = false;
    for (int i = 0; i < _weeks.length; i++) {
      for (int j = 0; j < _weeks[i].length; j++) {
        if (DateUtil.isSameDay(_weeks[i][j], widget.selectedDate)) {
          _currentPage = i;
          found = true;
          break;
        }
      }
      if (found) break;
    }
    
    // If not found, use the default (showing current week)
    if (!found) {
      _currentPage = _extraWeeks ~/ 2;
    }
    
    _pageController = PageController(initialPage: _currentPage);
    
    // Notify the parent about the current week
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onWeekChanged(_weeks[_currentPage]);
    });
    
    debugPrint("WeekDaySelector initialized with date: ${widget.selectedDate}, page: $_currentPage");
  }

  DateTime _getWeekStartDate(DateTime date) {
    // Weekday in Dart: 1=Monday, 7=Sunday
    final int weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  List<DateTime> _generateWeekDays(DateTime weekStart) {
    return List.generate(
      7, 
      (index) => weekStart.add(Duration(days: index))
    );
  }
  
  void _onPageChanged(int page) {
    if (_currentPage != page) {
      debugPrint("Page changed from $_currentPage to $page");
      setState(() {
        _currentPage = page;
      });
      widget.onWeekChanged(_weeks[page]);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building WeekDaySelector with selectedDate: ${widget.selectedDate}");
    
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: _weeks.length,
        itemBuilder: (context, pageIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    7,
                    (index) => SizedBox(
                      width: (constraints.maxWidth - 16) / 7,
                      child: _buildWeekDay(
                        context,
                        _weeks[pageIndex][index],
                        isSelected: DateUtil.isSameDay(_weeks[pageIndex][index], widget.selectedDate),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeekDay(BuildContext context, DateTime date, {bool isSelected = false}) {
    final dayName = DateFormat('E').format(date).substring(0, 3);
    final dayNumber = date.day.toString();
    final isToday = DateUtil.isSameDay(date, DateTime.now());
    
    return InkWell(
      onTap: () => widget.onDateSelected(date),
      borderRadius: BorderRadius.circular(18),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dayName,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.purple : Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.purple.shade300 : 
                       isToday ? Colors.purple.shade100 : Colors.transparent,
                border: isToday && !isSelected ? Border.all(color: Colors.purple.shade300, width: 1) : null,
              ),
              child: Center(
                child: Text(
                  dayNumber,
                  style: TextStyle(
                    color: isSelected ? Colors.white : 
                           isToday ? Colors.purple.shade700 : Colors.black,
                    fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}