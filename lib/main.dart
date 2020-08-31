import 'package:flutter/material.dart';
import 'package:flutter_app_plug_test/google_map_page.dart';

import 'bluetooth_page.dart';
import 'home_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        "blueToothTest": (context) => BlueToothPage(),
        "googleMapTest":(context) =>GoogleMapPage(),
        "/": (context) => MyHomePage(title: 'Flutter Demo Home Page'), //注册首页路由
      },
    );
  }
}
