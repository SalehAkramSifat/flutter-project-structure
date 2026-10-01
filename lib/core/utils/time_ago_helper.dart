class TimeAgoHelper {
  TimeAgoHelper._();

  /// Full relative time string (e.g. "Just now", "5 minutes ago", "2 hours ago", "3 days ago")
  static String getTimeAgo(dynamic dateTimeInput) {
    final DateTime? dateTime = _parseDateTime(dateTimeInput);
    if (dateTime == null) return 'Unknown time';

    try {
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(dateTime);

      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        final minutes = difference.inMinutes;
        return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
      } else if (difference.inHours < 24) {
        final hours = difference.inHours;
        return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inDays < 7) {
        final days = difference.inDays;
        return '$days ${days == 1 ? 'day' : 'days'} ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      }
    } catch (_) {
      return 'Unknown time';
    }
  }

  /// Short relative time string (e.g. "Just now", "5m ago", "2h ago", "3d ago", "2w ago")
  static String getShortTimeAgo(dynamic dateTimeInput) {
    final DateTime? dateTime = _parseDateTime(dateTimeInput);
    if (dateTime == null) return 'Unknown';

    try {
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(dateTime);

      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else if (difference.inDays < 30) {
        return '${(difference.inDays / 7).floor()}w ago';
      } else if (difference.inDays < 365) {
        return '${(difference.inDays / 30).floor()}mo ago';
      } else {
        return '${(difference.inDays / 365).floor()}y ago';
      }
    } catch (_) {
      return 'Unknown';
    }
  }

  static DateTime? _parseDateTime(dynamic input) {
    if (input == null) return null;
    if (input is DateTime) return input;
    if (input is String) {
      if (input.trim().isEmpty) return null;
      return DateTime.tryParse(input.trim());
    }
    return null;
  }
}

/*
================================================================================
💡 HOW TO USE TimeAgoHelper (EXAMPLES)
================================================================================

1. Full relative time (Ideal for social feeds, post details, comments, notifications):
   Text(TimeAgoHelper.getTimeAgo(post.createdAt))
   // Output examples:
   // - "Just now"
   // - "5 minutes ago"
   // - "2 hours ago"
   // - "3 days ago"
   // - "2 weeks ago"
   // - "1 year ago"

2. Short compact time (Ideal for chat list item, notification badge, compact cards):
   Text(TimeAgoHelper.getShortTimeAgo(chat.lastMessageTime))
   // Output examples:
   // - "Just now"
   // - "5m ago"
   // - "2h ago"
   // - "3d ago"
   // - "2w ago"
   // - "1y ago"

================================================================================
*/
