import 'dart:convert';

import 'package:test/test.dart';
import 'package:bicycle_trip_planner/models/weather_model.dart';

main() {
  final weatherInfo = WeatherInfo(description: "", icon: "");
  final weatherInfo2 = WeatherInfo(description: "", icon: "11d");
  final tempInfo = TemperatureInfo(temperature: 0);
  final weather = WeatherResponse(cityName: "London", tempInfo: tempInfo, weatherInfo: weatherInfo);
  final weather2 = WeatherResponse(cityName: "London", tempInfo: tempInfo, weatherInfo: weatherInfo2);

  test('test default icon when icon is empty', (){
    expect(weather.iconUrl, 'https://openweathermap.org/img/wn/10d@2x.png');
  });

  test('test return correct url when icon is defined', (){
    expect(weather2.iconUrl, 'https://openweathermap.org/img/wn/11d@2x.png');
  });

  test('test build weather from Json', (){
    String weatherJson = '{"name": "London", "main": {"temp": 0.0}, "weather": [{"description": "rain", "icon": "10d"}]}';
    expect(WeatherResponse.fromJson(jsonDecode(weatherJson)).cityName, "London");
    expect(WeatherResponse.fromJson(jsonDecode(weatherJson)).tempInfo.temperature, 0.0);
    expect(WeatherResponse.fromJson(jsonDecode(weatherJson)).weatherInfo.description, "rain");
    expect(WeatherResponse.fromJson(jsonDecode(weatherJson)).weatherInfo.icon, "10d");
  });

}