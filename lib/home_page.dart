import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                RaisedButton(
                  child: Text("bluetoothPlug"),
                  onPressed: () {
                    Navigator.pushNamed(context, "blueToothTest");
                  },
                ),
                RaisedButton(
                  child: Text("googleMapPlug"),
                  onPressed: () {
                    Navigator.pushNamed(context, "googleMapTest");
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
