
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'meteo.dart';

class Ville{
  String name ;
  String lat;
  String long;
  int timeOffset= 0;
  late Meteo meteo;

  Ville({required this.name ,required this.lat ,required this.long,this.timeOffset=0});

  @override
  String toString() {
    return name;
  }

  Future<Map<String, dynamic>> getJson() async {
    var lat = this.lat ;
    var long = this.long;

    var url = Uri.parse("http://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&hourly=temperature_2m,cloudcover&daily=temperature_2m_max,temperature_2m_min&timezone=Europe%2FLondon");
    Response response = await http.get(url);

    // sample info available in response
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String? contentType = headers['content-type'];
    Map<String,dynamic> data = await jsonDecode(response.body);

    return data;
  }

  getMeteo(Map<String,dynamic> json){
    meteo = Meteo.fromJson(json,timeOffset);
    return meteo ;
  }

}