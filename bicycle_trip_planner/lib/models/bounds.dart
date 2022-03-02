
class Bounds {
  final Map<String, dynamic> northeast;
  final Map<String, dynamic> southwest;

  Bounds({required this.northeast, required this.southwest});

  const Bounds.boundsNotFound({
    this.northeast = const {},
    this.southwest = const {}
});

  factory Bounds.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Bounds(
      northeast: parsedJson['northeast'],
      southwest: parsedJson['southwest'],
    );
  }
}
