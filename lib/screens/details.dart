import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sunny_weather/models/function.dart';

import '../models/VilleModel.dart';
import '../models/meteo.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, required this.ville}) : super(key: key);

  final Ville ville;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Ville _ville;
  late Meteo meteo;
  @override
  void initState() {
    super.initState();
    _ville = widget.ville;
    meteo = widget.ville.meteo;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body:Container(
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
          child:  Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.bottomCenter,
              children: [
                CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 30,
                      ),
                    ),
                    SliverAppBar(
                      pinned: false,
                      elevation: 6,
                      automaticallyImplyLeading: false,
                      centerTitle: false,
                      backgroundColor: Colors.transparent,
                      toolbarHeight: 200,
                      title:Container(
                        height: 200,
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
                            Text(meteo.currentTemp + '°',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 40,
                                )),
                            Text(meteo.currentCloudCover,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                            Container(
                              width: 150,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.arrow_upward,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    meteo.tempMaxDaily[0].toString() + '°',
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
                                    meteo.tempMinDaily[0].toString() + '°',
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
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 50,
                      ),
                    ),
                    SliverToBoxAdapter(
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
                            )
                        ),
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
                                              color:
                                              Colors.white.withOpacity(0.7))),
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
                                    height: 100,
                                    child: Center(
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: 24,
                                        itemBuilder: (context, index) {
                                          index= meteo.timeHourly.indexOf(DateFormat("yyyy-MM-ddTHH:00").format(DateTime.now().add(Duration(hours: index+1))));
                                          var hour = DateFormat().add_j().format(DateFormat("yyyy-MM-ddTHH:mm").parse(meteo.timeHourly[index]));
                                          return Container(
                                            width: 120,
                                            color: Colors.transparent,
                                            padding: const EdgeInsets.all(4),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(hour.toString(),
                                                    style: GoogleFonts.inter(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white)),
                                                Text(
                                                    getCloudCover(meteo
                                                        .cloudCoverHourly[index]),
                                                    style: GoogleFonts.inter(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white),
                                                    textAlign: TextAlign.center),
                                                Text(
                                                    meteo.tempHourly[index]
                                                        .toString() +
                                                        '°',
                                                    style: GoogleFonts.inter(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
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
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 50,
                      ),
                    ),
                    SliverToBoxAdapter(
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
                            )
                        ),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 3.0,
                              sigmaY: 3.0,
                            ),
                            child: Container(
                              height: 660,
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
                                              color:
                                              Colors.white.withOpacity(0.7))),
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
                                        Text("PREVISION FOR 7 DAYS",
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
                                    height: 600,
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: meteo.timeDaily.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          height: 80,
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.all(4),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 150,
                                                alignment: Alignment.center,
                                                child: Text(meteo.timeDaily[index],
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.inter(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white)),
                                              ),

                                              Container(
                                                width: 150,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.arrow_upward,
                                                      size: 15,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      meteo.tempMaxDaily[index].toString() + '°',
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
                                                      meteo.tempMinDaily[index].toString() + '°',
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
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 100,
                      ),
                    ),
                  ],
                ),
                Container(
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
                    ))
              ]),
        ),
      );
}
