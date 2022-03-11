import 'package:bicycle_trip_planner/models/place.dart';
import 'package:xml/xml.dart';

class Station {
  int id;
  String name;
  double lat;
  double lng;
  int bikes;
  int emptyDocks;
  int totalDocks;
  double distanceTo;
  Place place;

  Station(
      {required this.id,
      required this.name,
      required this.lat,
      required this.lng,
      required this.bikes,
      required this.emptyDocks,
      required this.totalDocks,
      this.distanceTo = 0.0,
      this.place = const Place.placeNotFound()
      });

  Station.stationNotFound(
      {this.id = 0,
      this.name = "Station Not Found",
      this.lat = 0,
      this.lng = 0,
      this.bikes = 0,
      this.emptyDocks = 0,
      this.totalDocks = 0,
      this.distanceTo = 0.0,
      this.place = const Place.placeNotFound()
      });

  factory Station.fromXml(XmlElement element) {
    return Station(
      id: int.parse(element.findElements("id").first.text),
      name: element.findElements("name").first.text,
      lat: double.parse(element.findElements("lat").first.text),
      lng: double.parse(element.findElements("long").first.text),
      bikes: int.parse(element.findElements("nbBikes").first.text),
      emptyDocks: int.parse(element.findElements("nbEmptyDocks").first.text),
      totalDocks: int.parse(element.findElements("nbDocks").first.text),
    );
  }

  double calculateStationAvailability() {
    return (bikes / totalDocks) * 50;
  }

  void update(Station station, double distance) {
    bikes = station.bikes;
    emptyDocks = station.emptyDocks;
    totalDocks = station.totalDocks;
    distanceTo = distance;
  }

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) {
    return other is Station && other.id == id && other.name == name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}
