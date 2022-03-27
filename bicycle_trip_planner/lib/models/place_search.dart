class PlaceSearch {
  final String description;
  final String placeId;

  /**
   * constructor with specified required inputs
   */
  PlaceSearch({required this.description, required this.placeId});

  /**
   * factory constructor when data is passed from Json
   * @param Map<String, dynamic> parsed Json
   */
  factory PlaceSearch.fromJson(Map<String, dynamic> json) {
    return PlaceSearch(
      description: json['description'],
      placeId: json['place_id'],
    );
  }
}
