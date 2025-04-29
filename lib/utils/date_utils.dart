class DateUtil {
  // Check if two dates are the same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Generate a list of dates for the current week
  static List<DateTime> generateWeekDays(DateTime date) {
    final int weekday = date.weekday;
    final startOfWeek = date.subtract(Duration(days: weekday - 1));
    
    return List.generate(
      7, 
      (index) => startOfWeek.add(Duration(days: index))
    );
  }
  
  // Get the first day of the month for a given date
  static DateTime getMonthStart(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
}