// lib/utils/date_utils.dart
class DateUtil {
  /// Check if two dates are the same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Get the start date of the current month
  static DateTime getMonthStart(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get the start date of the week containing the given date
  /// Returns the previous Monday (Monday as first day of week)
  static DateTime getWeekStart(DateTime date) {
    // Adjust for Monday as first day of week
    // Weekday in Dart: 1=Monday, 7=Sunday
    final int weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }
  
  /// Get a list of dates for the week containing the given date
  /// Starting with Monday
  static List<DateTime> getWeekDays(DateTime date) {
    final startDay = getWeekStart(date);
    return List.generate(
      7,
      (index) => startDay.add(Duration(days: index)),
    );
  }
  
  /// Generate a list of week days around the given date (compatibility method)
  static List<DateTime> generateWeekDays(DateTime date) {
    return getWeekDays(date);
  }
}