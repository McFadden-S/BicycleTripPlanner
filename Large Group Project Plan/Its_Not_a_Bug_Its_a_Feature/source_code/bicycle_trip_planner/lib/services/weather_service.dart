import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

/// Class Comment:
/// WeatherService is a service class that returns actual Weather

class WeatherService {

  /// @return WeatherResponse - actual weather in @param city
  Future<WeatherResponse> getWeather(String city) async {

    final queryParameters = {
      'q': city,
      'appid': 'f90aaab58a10ed03221dca9dc35bc0bc',
      'units': 'metric',
    };

    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);

    final response = await http.get(uri);

    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }
}
