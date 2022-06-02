import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sunny_weather/utils/constants.dart';
import 'package:sunny_weather/widgets/meteo_widgets.dart';

import '../models/VilleModel.dart';
import '../models/meteo.dart';




class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = FloatingSearchBarController();

  String value = "";
  bool isVisible = false;
  bool isCelsius = true ;
  late Ville maPosition ;

  List<Ville> listVille = [];
  List<Location> locations= [];
  List<Placemark> placemarks= [];

  late String placeAddress;
  late double latitude ;
  late double longitude ;

  List<Ville> listVilleinit = [];


  @override
  initState() {
    listVilleinit.add(Ville(name: 'Dakar',lat: '14.7667',long:'-17.2833'));
    listVilleinit.add(Ville(name: 'Paris',lat: '48.8567',long:'2.3510',timeOffset: 2));
    listVilleinit.add(Ville(name: 'London',lat: '51.5098',long:'-0.1180',));
    listVilleinit.add(Ville(name: 'Berlin',lat: '52.5316',long:'13.3817',timeOffset: 2));
    super.initState();

  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      //title: Text(MyApp.title),
      backgroundColor: CupertinoColors.systemGrey6.withOpacity(0.8),
      centerTitle: true,
      toolbarHeight:60,
      elevation: 0,
      title:Container(
        decoration: const BoxDecoration(
          color: CupertinoColors.systemGrey6,
        ),
        child: Row(
          children: [
            Text('Sunny',style: GoogleFonts.inter(
              fontSize: 20,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            )),
            Text('Weather',style: GoogleFonts.inter(
              fontSize: 30,
              color: Colors.lightBlueAccent,
              fontWeight: FontWeight.bold,
            ))
          ],
        ),
      ),
      actions: [
        Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.lightBlueAccent),
            textTheme: const TextTheme().apply(bodyColor: Colors.white),
          ),
          child:  Column(
            children: [
              PopupMenuButton<int>(
                icon: const Icon(CupertinoIcons.ellipsis_vertical_circle),
                color: thirdColor.withOpacity(0.8),
                onSelected: (item) => onSelected(context, item),
                iconSize: 40,
                elevation: 5,
                offset: const Offset(5, 50),
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child:ClipRect( child :BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 1.0,
                        sigmaY: 1.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 40,),
                          Text('Edit the list',style: GoogleFonts.inter(color: Colors.white,)),
                          const SizedBox(width: 40,),
                          const Icon(CupertinoIcons.pencil ,color: Colors.white),
                        ],
                      ),
                    )
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40,),
                        Text('Notifications',style: GoogleFonts.inter(color: Colors.white,)),
                        const SizedBox(width: 40,),
                        const Icon(Icons.add_alert,color: Colors.white),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isCelsius) const Icon(Icons.check,color: Colors.white) else const SizedBox(width: 40,),
                        Text('Celsius',style: GoogleFonts.inter(color: Colors.white,)),
                        const SizedBox(width: 40,),
                        Text('°C',style: GoogleFonts.inter(color: Colors.white,)),
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!isCelsius) const Icon(Icons.check,color: Colors.white) else const SizedBox(width: 40,),
                        Text('Fahrenheit',style: GoogleFonts.inter(color: Colors.white,)),
                        const SizedBox(width: 40,),
                        Text('°F',style: GoogleFonts.inter(color: Colors.white,)),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<int>(
                    value: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40,),
                        Text('Report an error',style: GoogleFonts.inter(color: Colors.white,)),
                        const SizedBox(width: 40,),
                        const Icon(Icons.warning_amber_outlined,color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
    body: Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                decoration : const BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                ),
                child: Column(
                  children: const [
                    SizedBox(height: 100),
                    SizedBox(height: 20)
                  ],
                ),
              ),
            ),
            SliverList(delegate: SliverChildListDelegate([
              FutureBuilder<List<Ville>>(
                future: getVille(listVilleinit),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(padding: EdgeInsets.only(top: 100,bottom: 100,left: 100,right: 100),
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Ville ville = snapshot.data[index];
                          return meteoWidgets(context, ville);
                        },
                        shrinkWrap: true,
                      );
                    } else {
                      return const Text('Empty data');
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                },

              )
            ]))
          ],
        ),
        FloatingSearchBar(
          controller: controller,
          hint: 'Search for locations ...',
          automaticallyImplyBackButton: false,
          scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
          transitionDuration: const Duration(milliseconds: 800),
          transitionCurve: Curves.easeInOut,
          physics: const BouncingScrollPhysics(),
          axisAlignment:  0.0 ,
          openAxisAlignment: 0.0,
          width: 500,
          debounceDelay: const Duration(milliseconds: 500),
          onQueryChanged: (query) {
            placemarks =[];
            locations = [];
            value = query ;
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
                icon: const Icon(Icons.search,color: Colors.lightBlueAccent),
                onPressed: () {
                  if(value.isNotEmpty){
                    autoCompleteSearch(value);
                  }
                },
              ),
            ),
            FloatingSearchBarAction(
              showIfOpened: false,
              child: CircularButton(
                icon: const Icon(Icons.place ,color: Colors.lightBlueAccent,),
                onPressed: () {
                },
              ),
            ),
            FloatingSearchBarAction.back(
              showIfClosed: false,
            ),
          ],
          builder: (context, transition) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: ListView.builder(
                  itemCount: placemarks.length,
                  itemBuilder: (context, index) {
                    Placemark place = placemarks[index];
                    String? name = place.name;
                    return Container(
                      height: 100,
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          SizedBox(width: 200,child:Text("Location: \n\n"+name!),),
                          const VerticalDivider(color: Colors.black,),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                placemarks=[];
                                listVilleinit.add(Ville(name: name,lat: latitude.toString(),long: longitude.toString()));
                                controller.close();
                                controller.clear();
                              });
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.add ,color: Colors.lightBlueAccent,),
                                Text("Add Location" ,style: GoogleFonts.inter( color: Colors.lightBlueAccent),)
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
        ),
      ],
    ),

  );

  onSelected(BuildContext context, int item)  {
    switch (item) {
      case 0:
        print('0');

        break;
      case 1:
        print('1');
        break;
      case 2:
        print('1');
        isCelsius = true;
        setState(() {

        });
        break;
      case 3:
        print('1');
        isCelsius = false;
        setState(() {

        });
        break;
      case 4:
        print('1');
    }
  }

  void autoCompleteSearch(String value) async {

    List<Location> locationF = await locationFromAddress(value);
    if(locationF.isNotEmpty){
      setState(() {
        locations = locationF ;
      });

      for(Location loc in locationF){
        latitude = double.parse(loc.latitude.toStringAsFixed(4));
        longitude = double.parse(loc.longitude.toStringAsFixed(4));
        List<Placemark> placemarkF = await placemarkFromCoordinates(latitude,longitude);
        if(placemarkF.isNotEmpty){
          setState(() {
            placemarks = placemarkF;
          });
        }
      }
    }
  }
}

Future<List<Ville>> getVille(List<Ville> listVilleInit) async {
  List<Ville> listVille = [];
  Map<String,dynamic> data;
  Meteo meteo;

 for (var v in listVilleInit){
   data = await v.getJson();
   meteo = v.getMeteo(data);
   v.meteo = meteo ;
   listVille.add(v);
 }

  return listVille;
}
