import 'dart:math';

class DistanceCalculator {
  /// Calculate distance between two points using Haversine formula
  /// Returns distance in kilometers
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    // Convert degrees to radians
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  /// Convert degrees to radians
  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  /// Format distance for display
  /// Returns "X.X km away" or "X m away"
  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      int meters = (distanceInKm * 1000).round();
      return '$meters m away';
    } else {
      return '${distanceInKm.toStringAsFixed(1)} km away';
    }
  }
}
