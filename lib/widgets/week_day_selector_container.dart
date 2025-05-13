import 'package:flutter/material.dart';
import 'package:project/widgets/week_day_selector.dart';

class WeekDaySelectorContainer extends StatefulWidget {
  final List<DateTime> weekDays;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Function(List<DateTime>) onWeekChanged;

  const WeekDaySelectorContainer({
    super.key,
    required this.weekDays,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onWeekChanged,
  });

  @override
  State<WeekDaySelectorContainer> createState() => _WeekDaySelectorContainerState();
}

class _WeekDaySelectorContainerState extends State<WeekDaySelectorContainer> {
  // Keep track of the previous selected date to detect changes
  DateTime? _previousSelectedDate;
  bool _forceRebuild = false;
  
  @override
  void initState() {
    super.initState();
    _previousSelectedDate = widget.selectedDate;
  }
  
  @override
  void didUpdateWidget(WeekDaySelectorContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if the selected date has changed significantly (not just the same day)
    // We compare year+month+day to avoid minor time differences causing false triggers
    if (_previousSelectedDate?.year != widget.selectedDate.year ||
        _previousSelectedDate?.month != widget.selectedDate.month ||
        _previousSelectedDate?.day != widget.selectedDate.day) {
      
      debugPrint("Date changed from $_previousSelectedDate to ${widget.selectedDate}");
      _previousSelectedDate = widget.selectedDate;
      
      // Set flag to force WeekDaySelector rebuild in the next build cycle
      setState(() {
        _forceRebuild = true;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // If we need to force a rebuild, create a new instance with a unique key
    if (_forceRebuild) {
      debugPrint("Forcing WeekDaySelector rebuild");
      
      // Reset the flag
      _forceRebuild = false;
      
      // Return with a unique key to force complete rebuild
      return WeekDaySelector(
        key: UniqueKey(),
        weekDays: widget.weekDays,
        selectedDate: widget.selectedDate,
        onDateSelected: widget.onDateSelected,
        onWeekChanged: widget.onWeekChanged,
      );
    }
    
    // Normal build - no forced rebuild needed
    return WeekDaySelector(
      weekDays: widget.weekDays,
      selectedDate: widget.selectedDate,
      onDateSelected: widget.onDateSelected,
      onWeekChanged: widget.onWeekChanged,
    );
  }
}