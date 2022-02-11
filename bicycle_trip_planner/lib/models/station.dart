import 'package:xml/xml.dart';

class Station{ 

  String name; 
  double lat;
  double long;  
  int bikes; 
  int emptyDocks; 
  int totalDocks;

  Station({required this.name, 
           required this.lat, 
           required this.long, 
           required this.bikes, 
           required this.emptyDocks, 
           required this.totalDocks});
  
  factory Station.fromXml(XmlElement element) {
    return Station(
      name: element.findElements("name").first.text,
      lat: double.parse(element.findElements("lat").first.text),
      long: double.parse(element.findElements("long").first.text),
      bikes: int.parse(element.findElements("nbBikes").first.text),
      emptyDocks: int.parse(element.findElements("nbEmptyDocks").first.text), 
      totalDocks: int.parse(element.findElements("nbDocks").first.text),
    );
  }
}