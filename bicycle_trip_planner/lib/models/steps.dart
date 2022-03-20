class Steps {
  final String instruction;
  final int distance;
  final int duration;

  Steps(
      {required this.instruction,
      required this.distance,
      required this.duration});

  Steps.stepsNotFound(
      {this.instruction = "", this.distance = 0, this.duration = 0});

  factory Steps.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Steps(
      instruction: parsedJson['html_instructions'],
      distance: parsedJson['distance']['value'],
      duration: parsedJson['duration']['value'],
    );
  }

  factory Steps.from(Steps other) {
    return Steps(instruction: other.instruction, distance: other.distance,
        duration: other.duration);
  }

  @override
  String toString() {
    return instruction;
  }

  @override
  bool operator ==(Object other) {
    return other is Steps &&
        other.instruction == instruction &&
        other.distance == distance &&
        other.duration == duration;
  }

  @override
  int get hashCode => Object.hash(instruction, distance, duration);
}
