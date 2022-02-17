
class Steps {
  final String instruction;
  final int distance;
  final int duration;

  Steps({this.instruction, this.distance, this.duration});

  factory Steps.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Steps(
      instruction: parsedJson['html_instructions'],
      distance: parsedJson['distance']['value'],
      duration: parsedJson['duration']['value'],
    );
  }
}
