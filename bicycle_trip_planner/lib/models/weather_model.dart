class WeatherInfo {
  final String description;
  final String icon;

  /// WeatherInfo constructors
  WeatherInfo({required this.description, required this.icon});

  const WeatherInfo.weatherInfoNotFound(
      {this.description = "", this.icon = ""});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    final description = json['description'];
    final icon = json['icon'];
    return WeatherInfo(description: description, icon: icon);
  }
}

class TemperatureInfo {
  final double temperature;

  /// TemperatureInfo constructors
  TemperatureInfo({required this.temperature});

  const TemperatureInfo.temperatureInfoNotFound({this.temperature = 0});

  factory TemperatureInfo.fromJson(Map<String, dynamic> json) {
    final temperature = json['temp'];
    return TemperatureInfo(temperature: temperature);
  }
}

class WeatherResponse {
  final String cityName;
  final TemperatureInfo tempInfo;
  final WeatherInfo weatherInfo;

  String get iconUrl {
    if (weatherInfo.icon == "") {
      return 'https://openweathermap.org/img/wn/10d@2x.png';
    } else {
      return 'https://openweathermap.org/img/wn/${weatherInfo.icon}@2x.png';
    }
  }

  /// WeatherResponse constructors
  WeatherResponse(
      {required this.cityName,
      required this.tempInfo,
      required this.weatherInfo});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    final cityName = json['name'];

    final tempInfoJson = json['main'];
    final tempInfo = TemperatureInfo.fromJson(tempInfoJson);

    final weatherInfoJson = json['weather'][0];
    final weatherInfo = WeatherInfo.fromJson(weatherInfoJson);

    return WeatherResponse(
        cityName: cityName, tempInfo: tempInfo, weatherInfo: weatherInfo);
  }

  WeatherResponse.weatherResponseNotFound(
      {this.cityName = "",
      this.tempInfo = const TemperatureInfo.temperatureInfoNotFound(),
      this.weatherInfo = const WeatherInfo.weatherInfoNotFound()});
}
