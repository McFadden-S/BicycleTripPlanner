import 'package:xml/xml.dart';

class Station{ 

  int id; 
  String name; 
  double lat;
  double lng;
  int bikes; 
  int emptyDocks; 
  int totalDocks;
  double distanceTo;

  Station({required this.id,
           required this.name, 
           required this.lat, 
           required this.lng,
           required this.bikes, 
           required this.emptyDocks, 
           required this.totalDocks,
           this.distanceTo = 0.0});

  Station.stationNotFound({
    this.id = 0,
    this.name = "Station Not Found",
    this.lat = 0,
    this.lng = 0,
    this.bikes = 0,
    this.emptyDocks = 0,
    this.totalDocks = 0,
    this.distanceTo = 0.0
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

  bool isStationNotFound(){
    return id == 0 && name == "Station Not Found";
  }
}