enum DistanceType {
  miles,
  km,
}

extension DistanceTypeExtension on DistanceType {
  double convert(double metres) {
    switch (this) {
      case DistanceType.miles:
        return metres / 1609.34;
      case DistanceType.km:
        return metres / 1000;
    }
  }

  String get units {
    switch (this) {
      case DistanceType.miles:
        return "mi";
      case DistanceType.km:
        return "km";
    }
  }

  String get unitsLong {
    switch (this) {
      case DistanceType.miles:
        return "miles";
      case DistanceType.km:
        return "kilometres";
    }
  }
}
