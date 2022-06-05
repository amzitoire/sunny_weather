
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:weather/weather.dart';

import 'function.dart';

class Ville {
  String name;
  String lat;
  String long;
  int timeOffset = 0;
  late String currentTime;
  late Weather weather ;
  late List<Weather> forecast;

  Ville(
      { required this.name,
        this.lat = "none",
        this.long="none",
        this.timeOffset = 0
      });

  @override
  String toString() {
    return name;
  }

  Future<Weather> getWeather() async {
    WeatherFactory wf = getWeatherFactory();
    Weather gweather;
    int offssetTime;
    if(lat == "none" && long == "none"){
      gweather = await wf.currentWeatherByCityName(name) ;
    }else{
      gweather = await wf.currentWeatherByLocation(double.parse(lat),double.parse(long)) ;
    }
    weather = gweather ;

    forecast = await wf.fiveDayForecastByCityName(name);

    offssetTime= await getTimeOffssetSeconds(weather);

    timeOffset = offssetTime;

    DateTime? date = gweather.date!.add(Duration(seconds: offssetTime));
    String hour= date.hour.toString();
    int weekday= date.weekday;
    int month= date.month;
    int day= date.day;

    currentTime = getCurrentTime(hour, weekday, month, day);

    return weather ;
  }

  Future<int> getTimeOffssetSeconds(Weather weather) async {

    var lat = weather.latitude;
    var long = weather.longitude;

    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=8d1bad42d4f729ec282bd29644edbcba"
    );
    Response response = await http.get(url);

    // sample info available in response
   /* int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String? contentType = headers['content-type'];*/
    Map<String, dynamic> data = await jsonDecode(response.body);

    int gtimeoffsset = data['timezone'];

    return gtimeoffsset;
  }

}
