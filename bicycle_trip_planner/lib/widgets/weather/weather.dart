import 'package:bicycle_trip_planner/widgets/weather/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  final _cityTextController = TextEditingController();
  final _weatherService = WeatherService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: SizedBox(
                    width: 150,
                    child: TextField(
                      controller: _cityTextController,
                      decoration: InputDecoration(labelText: 'City'),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ),
              ElevatedButton(onPressed: _search, child: Text('Search')),
            ],

          ),
        ),
      ),
    );
  }

  void _search() async{
    final response = await _weatherService.getWeather(_cityTextController.text);
    print(response.cityName);
    print(response.weatherInfo.description);
    print(response.tempInfo.temperature);
  }

}
