import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
// import 'package:location/location.dart' as LocationManager;

class GoogleMapPage extends StatefulWidget {
  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  // GoogleMapController mapController;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _myLocation = CameraPosition(
    target: LatLng(35.6580339, 139.7016358),
    zoom: 17.0,
  );

  LatLng _initialPosition = LatLng(37.42796133588664, -122.885740655967);
  Set<Marker> markers = Set(

  );
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: homeScaffoldKey,
        appBar: AppBar(
          title: Text("Test Of Map App"),
          backgroundColor: Colors.cyan,
        ),
        body:Stack(
          children: <Widget>[
            Container(
              child:
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: _myLocation,
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
            Container(
              child: SearchMapPlaceWidget(
                apiKey: "AIzaSyAPyQctQI4I_hKXicBWQJy1OZsQj0NR2pQ",
                // The language of the autocompletion
                language: 'en',
                // The position used to give better recomendations. In this case we are using the user position
                // location: userPosition.coordinates,
                // radius: 30000,
                onSelected: (Place place) async {
                  final geolocation = await place.geolocation;

                  // Will animate the GoogleMap camera, taking us to the selected position with an appropriate zoom
                  final GoogleMapController controller =
                      await _controller.future;
                  controller.animateCamera(
                      CameraUpdate.newLatLng(geolocation.coordinates));
                  controller.animateCamera(
                      CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                },
              ),
            )
          ],
        ));
  }
}
