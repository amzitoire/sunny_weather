import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sunny_weather/models/function.dart';
import 'package:weather/weather.dart';

import '../models/ville_model.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, required this.ville}) : super(key: key);

  final Ville ville;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Ville _ville;
  late Weather meteo;
  late List<Weather> forecast;
  
  @override
  void initState() {
    super.initState();
    _ville = widget.ville;
    meteo = widget.ville.weather;
    forecast = widget.ville.forecast;
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
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
          ),
          child: Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.bottomCenter,
              children: [
                CustomScrollView(
                  slivers: [
                    _sliverHeightDivider(30),
                      _weatherDescription(context, _ville, meteo),
                    _sliverHeightDivider(50),
                      _hourlyPrevision(context, _ville, forecast),
                    _sliverHeightDivider(50),
                    SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _weatherMiniWidget(context,Icons.water_outlined, "HUMIDITY", Icons.water_drop,meteo.humidity!.toStringAsFixed(0)+' %'),
                          _weatherMiniWidget(context,Icons.air, "WIND", Icons.air_outlined,meteo.windSpeed!.toStringAsFixed(0)+' km/h'),
                        ],
                      ),
                    ),
                    _sliverHeightDivider(20),
                    SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _weatherMiniWidget(context,CupertinoIcons.sunrise, "SUNRISE", Icons.wb_sunny_outlined,DateFormat("HH:mm").format(meteo.sunrise!.add(Duration(seconds: _ville.timeOffset)))),
                          _weatherMiniWidget(context,CupertinoIcons.sunset, "SUNSET", CupertinoIcons.moon,DateFormat("HH:mm").format(meteo.sunset!.add(Duration(seconds: _ville.timeOffset)))),
                        ],
                      ),
                    ),
                    _sliverHeightDivider(50),
                      _dayliPrevision(context, forecast),
                   _sliverHeightDivider(100),
                  ],
                ),
                _bottomNavbar(context)
              ]),
        ),
      );
}
  //widget
  _bottomNavbar(BuildContext context){
  return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          border: const Border(
              top: BorderSide(
                  color: Colors.white,
                  style: BorderStyle.solid,
                  width: 1))),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 18.0,
            sigmaY: 18.0,
          ),
          child: Container(
            height: 200,
            width: 200,
            color: Colors.white.withOpacity(0),
            child: Column(
              children: [
                CircularButton(
                  icon: const Icon(
                    Icons.list,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ));
}
  _hourlyPrevision(BuildContext context ,Ville _ville , List<Weather> forecast){
  return SliverToBoxAdapter(
    child: Container(
      margin: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent.withOpacity(0.7),
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [
              0.3,
              0.5,
              0.8,
            ],
            colors: [
              Colors.blueAccent,
              Colors.lightBlueAccent,
              Colors.blue,
            ],
          )),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3.0,
            sigmaY: 3.0,
          ),
          child: Container(
            height: 200,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 3,
                            style: BorderStyle.solid,
                            color: Colors.white
                                .withOpacity(0.7))),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("HOURLY PREVISION",
                          style: GoogleFonts.inter(
                            color:
                            Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 120,
                  child: Center(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        Weather weather = forecast[index];
                        var hour = weather.date!.add(Duration(seconds : _ville.timeOffset)).hour;

                        return Container(
                          width: 120,
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(hour.toString()+" h",
                                  style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Colors.white)),
                              _weatherIcon(weather.weatherIcon!, 40),
                              Text(
                                  weather.weatherDescription!,
                                  style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Colors.white),
                                  textAlign:
                                  TextAlign.center),
                              Text(
                                  weather.temperature!.celsius!.toStringAsFixed(1)+
                                      '°',
                                  style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  ) ;
}
  _dayliPrevision(BuildContext context ,List<Weather> forecast){
  return SliverToBoxAdapter(
    child: Container(
      margin: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent.withOpacity(0.7),
          gradient: const LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            stops: [
              0.3,
              0.5,
              0.8,
            ],
            colors: [
              Colors.blueAccent,
              Colors.lightBlueAccent,
              Colors.blue,
            ],
          )),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3.0,
            sigmaY: 3.0,
          ),
          child: Container(
            height: 460,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  height: 40,
                  // margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 3,
                            style: BorderStyle.solid,
                            color: Colors.white
                                .withOpacity(0.7))),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("PREVISION FOR 5 DAYS",
                          style: GoogleFonts.inter(
                            color:
                            Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const ClampingScrollPhysics(),
                    itemCount: forecast.length,
                    itemBuilder: (context, index) {
                      Weather weather = forecast[index];
                      return Container(
                        height: 80,

                        decoration: const BoxDecoration(
                            color: Colors.transparent,
                            border: Border(bottom: BorderSide(color: Colors.white,width: 1,style: BorderStyle.solid))
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150,
                              alignment: Alignment.center,
                              child: Text(
                                  getdailyTime(weather.date!.weekday,weather.date!.month, weather.date!.day,weather.date!.hour),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            SizedBox(
                              width: 150,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceAround,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.arrow_upward,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    weather.tempMax!.celsius!.toStringAsFixed(0)+
                                        '°',
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  const Icon(
                                    Icons.arrow_downward,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    weather.tempMin!.celsius!.toStringAsFixed(0)+
                                        '°',
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
  _weatherDescription(BuildContext context ,Ville _ville ,Weather meteo ){
  return SliverAppBar(
    pinned: false,
    elevation: 6,
    automaticallyImplyLeading: false,
    centerTitle: false,
    backgroundColor: Colors.transparent,
    toolbarHeight: 300,
    title: Container(
      height: 300,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_ville.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 30,
              )),
          Text(meteo.temperature!.celsius!.toStringAsFixed(1) + '°',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 40,
              )),
          _weatherIcon(meteo.weatherIcon!,75),
          Text(meteo.weatherDescription!,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
          const SizedBox(height: 10,),
          SizedBox(
            width: 150,
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.arrow_upward,
                  size: 15,
                  color: Colors.white,
                ),
                Text(
                  meteo.tempMax!.celsius!.toStringAsFixed(0) + '°',
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
                  meteo.tempMin!.celsius!.toStringAsFixed(0) + '°',
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
  _sliverHeightDivider(double height){
  return SliverToBoxAdapter(
    child: SizedBox(
      height: height,
    ),
  );
}
  _weatherMiniWidget(BuildContext context ,IconData icon ,String description,IconData meteoIcon,String data){
  double width = MediaQuery.of(context).size.width*0.42;
  return  Container(
      margin: const EdgeInsets.all(10),
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent.withOpacity(0.7),
          gradient: const LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            stops: [
              0.3,
              0.5,
              0.8,
            ],
            colors: [
              Colors.blueAccent,
              Colors.lightBlueAccent,
              Colors.blue,
            ],
          )),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3.0,
            sigmaY: 3.0,
          ),
          child: Container(
            height: 160,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 3,
                            style: BorderStyle.solid,
                            color: Colors.white
                                .withOpacity(0.7))),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(description,
                          style: GoogleFonts.inter(
                            color:
                            Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: width*0.8,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        Icon(meteoIcon ,color: Colors.white.withOpacity(0.7),),
                        Text(data,style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 20,
                        ),),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
}
  _weatherIcon(String icon, double size){
  return  SizedBox(
    width: size,
    height: size,
    child:Image.network("http://openweathermap.org/img/wn/"+icon+"@2x.png"),
  ) ;
  }