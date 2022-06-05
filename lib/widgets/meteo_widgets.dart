import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sunny_weather/screens/details.dart';
import 'package:weather/weather.dart';

import '../models/ville_model.dart';

  meteoWidgets(BuildContext context, Ville villeToFind , [bool isCelsius = true]) {

  Ville ville = villeToFind;
  Weather meteo = villeToFind.weather;

  getMeteo(context) async {
    meteo = await ville.getWeather();
  }
  getMeteo(context);

  return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailsPage(ville: ville);
        }));
      },
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            stops: [
              0.2,
              0.4,
              0.8,
            ],
            colors: [
              Colors.blueAccent,
              Colors.orangeAccent,
              Colors.lightBlueAccent,
            ],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.55,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ville.name,
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ville.currentTime,
                    style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _weatherIcon(meteo.weatherIcon!, 30),
                      Text(
                        meteo.weatherMain!,
                        style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  )

                ],
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isCelsius? meteo.temperature!.celsius!.toStringAsFixed(0)+ '°': meteo.temperature!.fahrenheit!.toStringAsFixed(0) + '°',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 35),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.arrow_upward,
                        size: 15,
                        color: Colors.white,
                      ),
                      Text(
                        isCelsius? meteo.tempMax!.celsius!.toStringAsFixed(0) + '°': meteo.tempMax!.fahrenheit!.toStringAsFixed(0)  + '°',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      const Icon(
                        Icons.arrow_downward,
                        size: 15,
                        color: Colors.white,
                      ),
                      Text(
                        isCelsius? meteo.tempMin!.celsius!.toStringAsFixed(0)+ '°': meteo.tempMin!.fahrenheit!.toStringAsFixed(0)  + '°',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ));
}

_weatherIcon(String icon, double size){
  return  SizedBox(
    width: size,
    height: size,
    child:Image.network("http://openweathermap.org/img/wn/"+icon+"@2x.png"),
  ) ;
}