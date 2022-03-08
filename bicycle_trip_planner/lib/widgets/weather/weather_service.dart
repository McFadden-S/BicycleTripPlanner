import 'package:http/http.dart' as http;

class WeatherService{
  void getWeather(String city) async{
    //api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

    final queryParameters = {'q': city, 'appid': 'f90aaab58a10ed03221dca9dc35bc0bc'};

    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', queryParameters);

    final response = await http.get(uri);

    print(response.body);
  }


}