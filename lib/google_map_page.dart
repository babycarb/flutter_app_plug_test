import 'dart:async';
// import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:search_map_place/search_map_place.dart';
// import 'package:location/location.dart' as LocationManager;

// class LocationData {
//   final double latitude; // Latitude, in degrees
//   final double longitude; // Longitude, in degrees
//   final double accuracy; // Estimated horizontal accuracy of this location, radial, in meters
//   final double altitude; // In meters above the WGS 84 reference ellipsoid
//   final double speed; // In meters/second
//   final double speedAccuracy; // In meters/second, always 0 on iOS
//   final double heading; //Heading is the horizontal direction of travel of this device, in degrees
//   final double time; //timestamp of the LocationData
// }
//
//
// enum LocationAccuracy {
//   powerSave, // To request best accuracy possible with zero additional power consumption,
//   low, // To request "city" level accuracy
//   balanced, // To request "block" level accuracy
//   high, // To request the most accurate locations available
//   navigation // To request location for navigation usage (affect only iOS)
// }
//
// // Status of a permission request to use location services.
// enum PermissionStatus {
//   /// The permission to use location services has been granted.
//   granted,
//   // The permission to use location services has been denied by the user. May have been denied forever on iOS.
//   denied,
//   // The permission to use location services has been denied forever by the user. No dialog will be displayed on permission request.
//   deniedForever
// }

class GoogleMapPage extends StatefulWidget {
  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  // GoogleMapController mapController;
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  final places =
      new GoogleMapsPlaces(apiKey: "AIzaSyA7RqhXhpfc5A026Z0kqX3Tb0wBaUpWJ4E");

  @override
  void initState() {
    print("这是git的测试提交，分支一");
    super.initState();
  }

  // LocationResult _pickedLocation;
  final Map<String, Marker> _markers = {};
  GoogleMapController mapController;

  static final CameraPosition _myLocation = CameraPosition(
    target: LatLng(35.6580339, 139.7016358),
    zoom: 17.0,
  );

  LatLng markerPosition = LatLng(35.6580339, 139.7016358);

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      // var options = MarkerOptions(
      //     position: LatLng(35.6580339,139.7016358)
      // );
      var marker = Marker(
          markerId: MarkerId("1"),
          position: markerPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          infoWindow: InfoWindow(title: "テストタイトル", snippet: "テスト内容"));
      _markers["テストタイトル"] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: homeScaffoldKey,
        appBar: AppBar(
          title: Text("Test Of Map App"),
          backgroundColor: Colors.cyan,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: _myLocation,
                markers: _markers.values.toSet(),
                onLongPress: (LatLng latLng) async {
                  // you have latitude and longitude here
//                   LocationResult result = await showLocationPicker(
//                     context, "AIzaSyA7RqhXhpfc5A026Z0kqX3Tb0wBaUpWJ4E",
//                     initialCenter: LatLng(31.1975844, 29.9598339),
// //                      automaticallyAnimateToCurrentLocation: true,
// //                      mapStylePath: 'assets/mapStyle.json',
//                     myLocationButtonEnabled: true,
//                     layersButtonEnabled: true,
//                     // countries: ['AE', 'NG']
//
// //                      resultCardAlignment: Alignment.bottomCenter,
//                   );
                  PlacesSearchResponse response =
                      await places.searchNearbyWithRadius(
                          new Location(latLng.latitude, latLng.longitude), 500);
                  setState(() {
                    // _pickedLocation = result;
                    _markers["テストタイトル"] = Marker(
                        markerId: MarkerId("1"),
                        position: latLng,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRose),
                        infoWindow: InfoWindow(
                            title: response.results[0].name,
                            snippet: response.results[1].name));
                  });
                  response.results.forEach((result) {
                    print('位置情報の確認！！！！！！！！！！！！！！！！！！！！！');
                    print(result.name);
                  });
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
            // Container(
            //   child: SearchMapPlaceWidget(
            //     apiKey: "AIzaSyAPyQctQI4I_hKXicBWQJy1OZsQj0NR2pQ",
            //     // The language of the autocompletion
            //     language: 'en',
            //     // The position used to give better recomendations. In this case we are using the user position
            //     // location: userPosition.coordinates,
            //     // radius: 30000,
            //     onSelected: (Place place) async {
            //       final geolocation = await place.geolocation;
            //
            //       // Will animate the GoogleMap camera, taking us to the selected position with an appropriate zoom
            //       final GoogleMapController controller =
            //           await mapController;
            //       controller.animateCamera(
            //           CameraUpdate.newLatLng(geolocation.coordinates));
            //       controller.animateCamera(
            //           CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
            //     },
            //   ),
            // )
          ],
        ));
  }

  InfoWindow newMethod(PlacesSearchResponse response) {
    return InfoWindow(
        title: response.results[0].name, snippet: response.results[1].name);
  }
}
