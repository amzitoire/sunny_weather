// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:splashscreen/splashscreen.dart';

import 'screens/home.dart';

void main() => runApp(const MyApp());

final routes = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: MyHomePage(title: 'Sunny Weather')),
  },
);

class MyApp extends StatelessWidget {
  static String title = 'Sunny Weather';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(
        seconds: 3,
        navigateAfterSeconds: MaterialApp.router(
          title: title,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
          routeInformationParser: const RoutemasterParser(),
        ),
        image: Image.asset('assets/images/sunny_weather_logo.bmp'),
        photoSize: 175,
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: const TextStyle(),
        loaderColor: Colors.blue,
      ),
    );
  }
}

