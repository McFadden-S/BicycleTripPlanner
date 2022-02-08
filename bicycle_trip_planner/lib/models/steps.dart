class Steps {
  final String instruction;
  final int distance;
  final int duration;

  Steps(
      {required this.instruction,
      required this.distance,
      required this.duration});

  factory Steps.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Steps(
      instruction: parsedJson['html_instructions'],
      distance: parsedJson['distance']['value'],
      duration: parsedJson['duration']['value'],
    );
  }
}
