import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/distance_types.dart';

main(){
  final km = DistanceType.km;
  final mi = DistanceType.miles;

  test('ensure units is km for km type', (){
    expect(km.units, "km");
    expect(km.unitsLong, "kilometres");
  });

  test('ensure units is miles for miles type', (){
    expect(mi.units, "mi");
    expect(mi.unitsLong, "miles");
  });

  test('ensure conversion is correct for km type', (){
    expect(km.convert(1000), 1);
  });

  test('ensure conversion is correct for miles type', (){
    expect(mi.convert(1609.34), 1);
  });

}