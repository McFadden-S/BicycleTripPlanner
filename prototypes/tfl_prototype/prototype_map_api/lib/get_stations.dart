import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import 'station.dart';

Future<String> retrieveRawData(http.Client client) async {
  var response = await client.get(Uri.parse('https://tfl.gov.uk/tfl/syndication/feeds/cycle-hire/livecyclehireupdates.xml'));
  print(response.body);
  return response.body;
}

XmlDocument convertToXML(String context) {
  var xmlResponse = XmlDocument.parse(context);
  return xmlResponse;
}

Iterable<Station> getStationsFromXML(XmlDocument data){
  var elements = data.findAllElements("station");
  return elements.map((element){
    return Station(
      name: element.findElements("name").first.text,
      lat: double.parse(element.findElements("lat").first.text),
      long: double.parse(element.findElements("long").first.text),
      bikes: int.parse(element.findElements("nbBikes").first.text),
      emptyDocks: int.parse(element.findElements("nbEmptyDocks").first.text),
      totalDocks: int.parse(element.findElements("nbDocks").first.text),
    );
  });
}

Future<Iterable<Station>> getStations(http.Client client) async {
  String context = await retrieveRawData(client);
  XmlDocument data = convertToXML(context);
  return getStationsFromXML(data);
}