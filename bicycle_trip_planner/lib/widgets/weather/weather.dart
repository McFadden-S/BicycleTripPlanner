import 'package:bicycle_trip_planner/constants.dart';
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
  Widget build(BuildContext context) {
    return Card(
      color: ThemeStyle.cardColor,
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(_response != null)
              Row(
                children: [
                  Image.network(_response.iconUrl, scale: 1.5,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_response.tempInfo.temperature}°C', style: TextStyle(fontSize: 25),),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );





  }


  void _search() async{
    final response = await _weatherService.getWeather("london");
    setState(() {
      _response = response;
    });
  }

}
