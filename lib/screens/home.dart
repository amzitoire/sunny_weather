import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sunny_weather/models/function.dart';
import 'package:sunny_weather/utils/constants.dart';
import 'package:sunny_weather/widgets/meteo_widgets.dart';
import 'package:weather/weather.dart';

import '../models/ville_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final controller = FloatingSearchBarController();

  String value = "";
  bool isCelsius = true;
  bool isEdit = false ;

  List<Ville> listVille = [];
  List<Location> locations = [];
  List<Ville> listVilleinit = [];
  List<Weather> listWeathers = [];

  late double latitude;
  late double longitude;

  @override
  initState() {
    listVilleinit.add(Ville(name: 'Dakar'));
    listVilleinit.add(Ville(name: 'Paris'));
    listVilleinit.add(Ville(name: 'London'));
    listVilleinit.add(Ville(name: 'Berlin'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: CupertinoColors.systemGrey6.withOpacity(0.8),
          centerTitle: true,
          toolbarHeight: 60,
          elevation: 0,
          title:_title(),
          actions: [
            _optionMenu(),
          ],
        ),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                _sliverTopSpace(),
                if(listVilleinit.isEmpty) _sliverListEmpty(),
                _locationList()
              ],
            ),
            _searchBar(),
          ],
        ),
      );

  //widget
  _title(){
    return  Container(
      decoration: const BoxDecoration(
        color: CupertinoColors.systemGrey6,
      ),
      child: Row(
        children: [
          Text('Sunny',
              style: GoogleFonts.inter(
                fontSize: 20,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              )),
          Text('Weather',
              style: GoogleFonts.inter(
                fontSize: 30,
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.bold,
              ))
        ],
      ),
    );
  }
  _searchBar(){
    return FloatingSearchBar(
      controller: controller,
      hint: 'Search for a City ...',
      automaticallyImplyBackButton: false,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: 0.0,
      openAxisAlignment: 0.0,
      width: 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        listWeathers =[];
        locations = [];
        value = query;
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: true,
          showIfClosed: false,
          child: CircularButton(
            icon:
            const Icon(Icons.search, color: Colors.lightBlueAccent),
            onPressed: () {
              if (value.isNotEmpty) {
                autoCompleteSearch(value);
              }
            },
          ),
        ),
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(
              Icons.place,
              color: Colors.lightBlueAccent,
            ),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction(
          showIfOpened: true,
          showIfClosed: false,
          child: CircularButton(
            icon:
            const Icon(Icons.arrow_back_outlined, color: Colors.lightBlueAccent),
            onPressed: () {
              listWeathers = [];
              controller.clear();
              controller.close();
            },
          ),
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: ListView.builder(
              itemCount: listWeathers.length,
              itemBuilder: (context, index) {
                Weather place = listWeathers[index];
                String? name = place.areaName;
                return Container(
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text("Location: \n\n" + name!),
                      ),
                      const VerticalDivider(
                        color: Colors.black,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            listWeathers =[];
                            listVilleinit.add(Ville(name: name));
                            controller.close();
                            controller.clear();

                            Fluttertoast.showToast(
                                msg: "city: $name added successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white.withOpacity(0.7),
                                textColor: Colors.lightBlueAccent,
                                fontSize: 20.0
                            );
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add,
                              color: Colors.lightBlueAccent,
                            ),
                            Text(
                              "Add Location",
                              style: GoogleFonts.inter(
                                  color: Colors.lightBlueAccent),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              shrinkWrap: true,
            ),
          ),
        );
      },
    ) ;
  }
  _optionMenu(){
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.lightBlueAccent),
        textTheme: const TextTheme().apply(bodyColor: Colors.white),
      ),
      child: Column(
        children: [
          PopupMenuButton<int>(
            icon: const Icon(CupertinoIcons.ellipsis_vertical_circle),
            color: Colors.lightBlue.withOpacity(0.6),
            onSelected: (item) => onSelected(context, item),
            iconSize: 40,
            elevation: 5,
            offset: const Offset(5, 50),
            itemBuilder: (context) =>
            [
              PopupMenuItem<int>(
                value: 0,
                child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 1.0,
                        sigmaY: 1.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [
                          const SizedBox(
                            width: 40,
                          ),
                          Text('Edit the list',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                              )),
                          const SizedBox(
                            width: 40,
                          ),
                          const Icon(CupertinoIcons.pencil,
                              color: Colors.white),
                        ],
                      ),
                    )),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isCelsius)
                      const Icon(Icons.check, color: Colors.white)
                    else
                      const SizedBox(
                        width: 40,
                      ),
                    Text('Celsius',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                        )),
                    const SizedBox(
                      width: 40,
                    ),
                    Text('°C',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!isCelsius)
                      const Icon(Icons.check, color: Colors.white)
                    else
                      const SizedBox(
                        width: 40,
                      ),
                    Text('Fahrenheit',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                        )),
                    const SizedBox(
                      width: 40,
                    ),
                    Text('°F',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<int>(
                value: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 40,
                    ),
                    Text('Report an error',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                        )),
                    const SizedBox(
                      width: 40,
                    ),
                    const Icon(Icons.warning_amber_outlined,
                        color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  _locationList(){
    return SliverList(
        delegate: SliverChildListDelegate([
          FutureBuilder<List<Ville>>(
            future: getVille(listVilleinit),
            builder: (BuildContext context,
                AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.lightBlueAccent,),
                );
              } else if (snapshot.connectionState ==
                  ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                      child :Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Error...'),
                            TextButton(onPressed: (){
                              setState(() {});
                            }, child:const Text('reload'))
                          ])
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Ville ville = snapshot.data[index];
                      var name = ville.name;
                      return Column(

                        children: [
                         if(isEdit) Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.trash_circle_fill,color: Colors.redAccent,),
                          TextButton(onPressed: (){
                            listVilleinit.removeAt(index);
                            isEdit=false;
                            setState(() {});
                          }, child: Text("Delete $name" ,style: GoogleFonts.inter(
                              color: Colors.red,
                          ),))
                        ],
                         ),
                          meteoWidgets(context, ville,isCelsius)
                        ],
                      );
                    },
                    shrinkWrap: true,
                  );
                } else {
                  return const Text('Add a location');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            },
          )
        ]));
  }
  _sliverTopSpace(){
    return const SliverToBoxAdapter(
      child: SizedBox(
        height: 110,
      ),
    );
  }
  _sliverListEmpty(){
    return  SliverToBoxAdapter(
        child: Center(
          child :Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.add_circled_solid,color: primaryColor),
              const SizedBox(width: 5,),
              Text("Add a city with the searchbar...",style: GoogleFonts.inter(
                  color: Colors.lightBlueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ))

            ],
          )
          ,
        ),
    );
  }

  //function
  Future<List<Ville>> getVille(List<Ville> listVilleInit) async {
    List<Ville> listVille = [];

    for (var v in listVilleInit) {
      v.weather= await v.getWeather();
      listVille.add(v);
    }

    return listVille;
  }
  void autoCompleteSearch(String value) async {

    List<Weather> lw = [];

    Weather byname = await getWeatherFactory().currentWeatherByCityName(value);
    lw.add(byname);

    try{

      List<Location> locationF = await locationFromAddress(value);
      if (locationF.isNotEmpty) {
        setState(() {
          locations = locationF;
        });

        for (Location loc in locationF) {
          latitude = double.parse(loc.latitude.toStringAsFixed(4));
          longitude = double.parse(loc.longitude.toStringAsFixed(4));

          Weather weather= await getWeatherFactory().currentWeatherByLocation(latitude, longitude);
          lw.add(weather);
        }

        setState(() {
          listWeathers = lw ;
        });

      }

    }on NoResultFoundException catch (_){
      Fluttertoast.showToast(
          msg: "No City found ...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white.withOpacity(0.7),
          textColor: Colors.lightBlueAccent,
          fontSize: 20.0
      );
    }


  }
  onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        isEdit = !isEdit;
        setState(() {});
        break;
      case 2:

        isCelsius = true;
        setState(() {});
        break;
      case 3:
        isCelsius = false;
        setState(() {});
        break;
      case 4:

    }
  }

}
