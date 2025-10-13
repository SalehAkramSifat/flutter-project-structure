
  String formatDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return date ?? '';
    }
  }

  String formatDateWithSuffix(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsedDate = DateTime.parse(date);
      final day = parsedDate.day;
      final suffix = getDaySuffix(day);
      final monthYear = DateFormat('MMM yyyy').format(parsedDate);
      final weekday = DateFormat('EEE').format(parsedDate);
      return '$weekday, $day$suffix $monthYear';
    } catch (e) {
      return date ?? '';
    }
  }

  String getDaySuffix(int day) {
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
