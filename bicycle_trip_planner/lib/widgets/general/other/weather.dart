import 'package:bicycle_trip_planner/constants.dart';
import 'package:bicycle_trip_planner/models/weather_model.dart';
import 'package:bicycle_trip_planner/services/weather_service.dart';
import 'package:flutter/material.dart';

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  final _weatherService = WeatherService();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ThemeStyle.cardColor,
      child: FutureBuilder<WeatherResponse>(
          future: _weatherService.getWeather('london'),
          builder: (context, snapshot) {
            WeatherResponse weatherResponse =
                WeatherResponse.weatherResponseNotFound();
            if (snapshot.data != null) {
              weatherResponse = snapshot.data!;
            }
            return weatherResponse != WeatherResponse.weatherResponseNotFound()
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (weatherResponse.weatherInfo.icon != "")
                        Column(
                          children: [
                            Image.network(
                              weatherResponse.iconUrl,
                              scale: 1.7,
                            ),
                            Text(
                              '${weatherResponse.tempInfo.temperature.round()}°C',
                              style: TextStyle(
                                  color: ThemeStyle.primaryTextColor,
                                  fontSize: 20),
                            ),
                            SizedBox(height: 10)
                          ],
                        ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                        color: ThemeStyle.primaryTextColor),
                  );
          }),
    );
  }
}
