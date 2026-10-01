import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// Example: 26/09/2025
  static String simpleDate(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      return DateFormat('dd/MM/yyyy').format(parsed);
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: 26 Sep 2025
  static String shortDate(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: Thu, 26 Sep 2025
  static String longDate(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      return DateFormat('EEE, dd MMM yyyy').format(parsed);
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: Thu, 26th Sep 2025
  static String dateWithSuffix(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      final day = parsed.day;
      final suffix = _getDaySuffix(day);
      final monthYear = DateFormat('MMM yyyy').format(parsed);
      final weekday = DateFormat('EEE').format(parsed);
      return '$weekday, $day$suffix $monthYear';
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: Thu, 26th
  static String dateAndMonth(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      final day = parsed.day;
      final suffix = _getDaySuffix(day);
      final weekday = DateFormat('EEE').format(parsed);
      return '$weekday, $day$suffix';
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: Thursday, 26 September 2025
  static String fullDate(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      return DateFormat('EEEE, dd MMMM yyyy').format(parsed);
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: 3:45 PM
  static String timeOnly(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      return DateFormat('h:mm a').format(parsed);
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: 15:45
  static String timeOnly24(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      return DateFormat('HH:mm').format(parsed);
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: 26/09/2025 03:45 PM
  static String fullDateTime(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      return DateFormat('dd/MM/yyyy hh:mm a').format(parsed);
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: 26/09/2025 15:45
  static String fullDateTime24(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      return DateFormat('dd/MM/yyyy HH:mm').format(parsed);
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: Sep 2025
  static String monthYear(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      return DateFormat('MMM yyyy').format(parsed);
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: Today
  static String relativeDay(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      final now = DateTime.now();
      final nowDate = DateTime(now.year, now.month, now.day);
      final parsedDate = DateTime(parsed.year, parsed.month, parsed.day);
      final difference = nowDate.difference(parsedDate).inDays;

      if (difference == 0) return 'Today';
      if (difference == 1) return 'Yesterday';
      if (difference == -1) return 'Tomorrow';
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: 2025-09-26T15:45:00.000
  static String isoString(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      return parsed.toIso8601String();
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: Thu, 26
  static String weekdayDay(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      return DateFormat('EEE, dd').format(parsed);
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: 26 Sep
  static String dayMonth(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      return DateFormat('dd MMM').format(parsed);
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: Thursday, 26 September
  static String weekdayDayMonth(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      return DateFormat('EEEE, dd MMMM').format(parsed);
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Example: 15 Jun 2025 02:01 PM
  static String customDateTime(dynamic date) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      return DateFormat('dd MMM yyyy hh:mm a').format(parsed);
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  static String format(dynamic date, String pattern) {
    final parsed = _parseDate(date);
    if (parsed == null) return date?.toString() ?? '';
    try {
      return DateFormat(pattern).format(parsed);
    } catch (_) {
      return date?.toString() ?? '';
    }
  }

  /// Helper to safely parse both DateTime and String inputs
  static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is String) {
      if (date.trim().isEmpty) return null;
      return DateTime.tryParse(date.trim());
    }
    return null;
  }

  /// Utility: day suffix (st, nd, rd, th)
  static String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}

/*
================================================================================
💡 HOW TO USE DateFormatter (EXAMPLES)
================================================================================

1. In UI / Text Widget (with API String):
   Text(DateFormatter.simpleDate(user.createdAt))     // Output: 26/09/2025
    
================================================================================
*/
