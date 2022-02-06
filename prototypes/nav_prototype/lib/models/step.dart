
class Step {
  final String instruction;
  final int distance;
  final int duration;

  Step({this.instruction, this.distance, this.duration});

  factory Step.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Step(
      instruction: parsedJson['html_instructions'],
      distance: parsedJson['distance']['value'],
      duration: parsedJson['duration']['value'],
    );
  }
}
