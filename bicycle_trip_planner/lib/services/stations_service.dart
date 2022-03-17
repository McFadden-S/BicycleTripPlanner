import 'package:bicycle_trip_planner/models/station.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class StationsService {
  Future<List<Station>> getStations(http.Client client) async {
    var url =
        'https://tfl.gov.uk/tfl/syndication/feeds/cycle-hire/livecyclehireupdates.xml';
    var response = await client.get(Uri.parse(url));
    var xmlResponse = XmlDocument.parse(response.body); 
    
    var elements = xmlResponse.findAllElements("station"); 
    return elements.map((element) => Station.fromXml(element)).toList();
  }
}