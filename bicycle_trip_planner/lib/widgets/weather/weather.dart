import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {

  String location = 'London';
  int woeid = 44418;
  String searchApiUrl = 'https://www.metaweather.com/api/location/search/?query=london';
  String locationApiUrl = 'https://www.metaweather.com/api/location/';

  void fetchSearch(String city) async {
    var searchResult = await http.get(Uri.parse(searchApiUrl + city));
    var result = json.decode(searchResult.body)[0];

    setState(() {
      location = result["title"];
      woeid = result["woeid"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
