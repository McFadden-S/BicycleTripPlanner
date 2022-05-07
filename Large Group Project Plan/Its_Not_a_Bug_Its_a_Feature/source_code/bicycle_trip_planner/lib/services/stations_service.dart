import 'package:bicycle_trip_planner/models/station.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

/// Class Comment:
/// StationService is a service class that returns bike stations
/// from tfl.gov.uk website

class StationsService {

  /// @return List<Station> - list of all actual bike stations
  Future<List<Station>> getStations() async {
    var url =
        'https://tfl.gov.uk/tfl/syndication/feeds/cycle-hire/livecyclehireupdates.xml';
    var response = await http.get(Uri.parse(url));
    var xmlResponse = XmlDocument.parse(response.body); 
    
    var elements = xmlResponse.findAllElements("station"); 
    return elements.map((element) => Station.fromXml(element)).toList();
  }
}