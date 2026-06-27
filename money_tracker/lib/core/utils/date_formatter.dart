import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// Returns "15 Jan 2025"
  static String format(DateTime date) {
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }

  /// Returns "15 Jan"
  static String formatShort(DateTime date) {
    return DateFormat('d MMM', 'id_ID').format(date);
  }

  /// Returns "January 2025"
  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy', 'en_US').format(date);
  }

  /// Returns "Today", "Yesterday", or "15 January 2025"
  static String formatGroupHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) {
      return 'Today';
    } else if (target == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMMM yyyy', 'en_US').format(date);
    }
  }

  /// Returns true if both dates fall on the same calendar day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
