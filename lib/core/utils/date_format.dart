import 'package:intl/intl.dart';

class DateFormatter {
  /// 1️⃣ Simple date: dd/MM/yyyy → 26/09/2025
  static String simpleDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  /// 2️⃣ Short date with month name: dd MMM yyyy → 26 Sep 2025
  static String shortDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  /// 3️⃣ Long date with weekday: EEE, dd MMM yyyy → Thu, 26 Sep 2025
  static String longDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('EEE, dd MMM yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  /// 4️⃣ Full date with day suffix: Thu, 26th Sep 2025
  static String dateWithSuffix(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      final day = parsed.day;
      final suffix = _getDaySuffix(day);
      final monthYear = DateFormat('MMM yyyy').format(parsed);
      final weekday = DateFormat('EEE').format(parsed);
      return '$weekday, $day$suffix $monthYear';
    } catch (e) {
      return date;
    }
  }

  static String dateAndMonth(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      final day = parsed.day;
      final suffix = _getDaySuffix(day);
      final weekday = DateFormat('EEE').format(parsed);
      return '$weekday, $day$suffix';
    } catch (e) {
      return date;
    }
  }

  /// 5️⃣ Full date with full weekday & month: Thursday, 26 September 2025
  static String fullDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('EEEE, dd MMMM yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  /// 6️⃣ Time only (12-hour): h:mm a → 3:45 PM
  static String timeOnly(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('h:mm a').format(parsed);
    } catch (e) {
      return date;
    }
  }

  /// 7️⃣ Time only (24-hour): HH:mm → 15:45
  static String timeOnly24(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('HH:mm').format(parsed);
    } catch (e) {
      return date;
    }
  }

  /// 8️⃣ Full date + time (12-hour): dd/MM/yyyy hh:mm a → 26/09/2025 03:45 PM
  static String fullDateTime(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy hh:mm a').format(parsed);
    } catch (e) {
      return date;
    }
  }

  /// 9️⃣ Full date + time (24-hour): dd/MM/yyyy HH:mm → 26/09/2025 15:45
  static String fullDateTime24(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy HH:mm').format(parsed);
    } catch (e) {
      return date;
    }
  }

  /// 🔟 Month-Year only: MMM yyyy → Sep 2025
  static String monthYear(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('MMM yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  /// 11️⃣ Relative format: Today / Yesterday / else dd MMM yyyy
  static String relativeDay(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      final now = DateTime.now();
      final difference = now.difference(parsed).inDays;
      if (difference == 0) return 'Today';
      if (difference == 1) return 'Yesterday';
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  /// 12️⃣ ISO 8601 string → 2025-09-26T15:45:00.000Z
  static String isoString(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return parsed.toIso8601String();
    } catch (e) {
      return date;
    }
  }

  /// 13️⃣ Weekday + day: EEE, dd → Thu, 26
  static String weekdayDay(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('EEE, dd').format(parsed);
    } catch (e) {
      return date;
    }
  }

  static String dayMonth(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMM').format(parsed);
    } catch (e) {
      return date;
    }
  }

  /// 14️⃣ Full weekday + day + month: EEEE, dd MMMM → Thursday, 26 September
  static String weekdayDayMonth(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('EEEE, dd MMMM').format(parsed);
    } catch (e) {
      return date;
    }
  }

  /// 16️⃣ Custom format: dd MMM yyyy hh:mm a → 15 Jun 2025 02:01 PM
  static String customDateTime(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMM yyyy hh:mm a').format(parsed);
    } catch (e) {
      return date;
    }
  }

  /// 15️⃣ Utility: day suffix
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