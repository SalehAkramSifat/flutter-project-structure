import 'dart:math';

class DistanceCalculator {
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371;

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

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      int meters = (distanceInKm * 1000).round();
      return '$meters m away';
    } else {
      return '${distanceInKm.toStringAsFixed(1)} km away';
    }
  }
}
