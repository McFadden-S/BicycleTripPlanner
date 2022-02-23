import 'package:test/test.dart';
import 'package:bicycle_trip_planner/managers/RouteManager.dart';

void main(){
  final routeManager = RouteManager();

  test('ensure that start is empty when initialized', (){
    expect(routeManager.getStart(), "");
  });

  test('ensure that destination is empty when initialized', (){
    expect(routeManager.getDestination(), "");
  });

  test('ensure that intermediaries are empty when initialized', (){
    expect(routeManager.getIntermediates().length, 0);
  });

  test('ensure that start is changed when requested', (){
    routeManager.setStart("Bush House");
    expect(routeManager.getStart(), "Bush House");
    expect(routeManager.ifChanged(), true);
    expect(routeManager.ifStartSet(), true);
  });

  test('ensure that start can be cleared when requested', (){
    routeManager.clearStart();
    expect(routeManager.getStart(), "");
    routeManager.clearChanged();
    expect(routeManager.ifChanged(), false);
    expect(routeManager.ifStartSet(), false);
  });

  test('ensure that destination is changed when requested', (){
    routeManager.setDestination("Bush House");
    expect(routeManager.getDestination(), "Bush House");
    expect(routeManager.ifChanged(), true);
    expect(routeManager.ifDestinationSet(), true);
  });

  test('ensure that destination can be cleared when requested', (){
    routeManager.clearDestination();
    expect(routeManager.getDestination(), "");
    routeManager.clearChanged();
    expect(routeManager.ifChanged(), false);
    expect(routeManager.ifDestinationSet(), false);
  });

  test('ensure that intermediaries can be set when requested with valid id', (){
    expect(routeManager.getIntermediates().length, 0);
    routeManager.setIntermediate("Bush House", 1);
    expect(routeManager.getIntermediates().length, 1);
  });

  test('ensure that number of intermediaries do not changed when existing id is changed', (){
    expect(routeManager.getIntermediates().length, 1);
    routeManager.setIntermediate("Bush House", 1);
    expect(routeManager.getIntermediates().length, 1);
  });

  test('ensure can remove intermediary using id', (){
    routeManager.removeIntermediate(1);
    expect(routeManager.getIntermediates().length, 0);
  });

}