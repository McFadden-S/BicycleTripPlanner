class Bounds {
  final Map<String, dynamic> northeast;
  final Map<String, dynamic> southwest;

  /**
   * constructor with specified required inputs
   */
  Bounds({required this.northeast, required this.southwest});

  /**
   * constructor default assignments when bounds are not found
   */
  const Bounds.boundsNotFound(
      {this.northeast = const {}, this.southwest = const {}});

  /**
   * factory constructor when data is passed from Json
   * @param Map<dynamic, dynamic> parsed Json
   */
  factory Bounds.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Bounds(
      northeast: parsedJson['northeast'],
      southwest: parsedJson['southwest'],
    );
  }

  /**
   * override the == operator
   * @return bool of whether the object is same or not
   */
  @override
  bool operator ==(Object other) {
    return other is Bounds &&
        other.northeast == northeast &&
        other.southwest == southwest;
  }

  /**
   * method override the get hashCode method
   * @return int of the hashCode
   */
  @override
  int get hashCode => Object.hash(northeast, southwest);
}
