import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/bounds.dart';

main(){
  final bounds = Bounds(northeast: Map<String, dynamic>(), southwest: Map<String, dynamic>());

  test('ensure southwest Map is empty when initialized', (){
    expect(bounds.southwest.length, 0);
  });

  test('ensure northeast Map is empty when initialized', (){
    expect(bounds.northeast.length, 0);
  });

  test('ensure == operator functions correctly', (){
    final bounds2 = Bounds(northeast: Map<String, dynamic>(), southwest: Map<String, dynamic>());
    expect(bounds == bounds2, false);
  });

}