enum DistanceType {
  miles,
  km,
}

extension DistanceTypeExtension on DistanceType {

  /// method converts the metres given to specified enum DistanceType
  /// @param double metres to convert
  /// @return converted distance
  double convert(double metres) {
    switch (this) {
      case DistanceType.miles:
        return metres / 1609.34;
      case DistanceType.km:
        return metres / 1000;
    }
  }

  /// method returns the String of a specified enum DistanceType
  /// @return String of units
  String get units {
    switch (this) {
      case DistanceType.miles:
        return "mi";
      case DistanceType.km:
        return "km";
    }
  }

  /// method returns the String of the full specified enum DistanceType
  /// @return String of long units
  String get unitsLong {
    switch (this) {
      case DistanceType.miles:
        return "miles";
      case DistanceType.km:
        return "kilometres";
    }
  }
}
