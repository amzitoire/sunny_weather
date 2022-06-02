import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sunny_weather/screens/details.dart';

import '../models/VilleModel.dart';
import '../models/meteo.dart';

meteoWidgets(BuildContext context ,Ville villeToFind) {
  Meteo meteo = villeToFind.meteo;
  Ville ville=villeToFind;
   getMeteo(context) async {
    Map<String,dynamic> data = await ville.getJson();
    meteo =  ville.getMeteo(data);
  }
  getMeteo(context);

  return  GestureDetector(
      onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DetailsPage(ville: ville);
    }));
  },
  child: Container(
    height: 125,
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.only(left: 10 , right: 10, bottom: 5 ,top: 5),
    decoration:BoxDecoration(
      //color: Colors.black,
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
      boxShadow:  [
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
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ville.name, style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),),
                Text(meteo.currentTime, style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ),),
                const SizedBox( height: 40),
                Text(meteo.currentCloudCover, style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ),),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(meteo.currentTemp+'°', style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 35
                ),),
                const SizedBox( height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_upward,size: 15, color: Colors.white,),
                    Text(meteo.tempMaxDaily[0].toString()+'°', style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),),
                    const Icon(Icons.arrow_downward,size: 15, color: Colors.white,),
                    Text(meteo.tempMinDaily[0].toString()+'°', style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),),
                  ],
                )
              ],
            ),
          )
        ],
      ),
  )
  );
}