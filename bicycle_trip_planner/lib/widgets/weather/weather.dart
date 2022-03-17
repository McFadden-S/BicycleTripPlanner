import 'package:bicycle_trip_planner/widgets/weather/weather_model.dart';
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
  final _weatherService = WeatherService();
  late WeatherResponse _response = WeatherResponse(cityName: "", tempInfo: TemperatureInfo(temperature: 0), weatherInfo: WeatherInfo(description: "", icon: ""));

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      return true;
    },
    child:
    Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(_response != null)
                    Column(
                      children: [
                        Text('London', style: TextStyle(fontSize: 30)),
                        Image.network(_response.iconUrl),
                        Text('${_response.tempInfo.temperature}°', style: TextStyle(fontSize: 40),),
                        Text(_response.weatherInfo.description),
                        BackButton()
                      ],
                    ),
                ],

              ),
            ),
          ),
  );

  void _search() async{
    final response = await _weatherService.getWeather("london");
    setState(() {
      _response = response;
    });
  }

}
