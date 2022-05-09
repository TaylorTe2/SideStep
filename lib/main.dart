<<<<<<< HEAD
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
=======
import 'dart:ui';
import 'UserSettings.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:math' show cos, sqrt, asin;
>>>>>>> 381e2abaa3dd19be69b1c94f9699b8612bde82e1

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;

//default starting position on map when the app is run. We should change this to device location in the future.
  final LatLng _center = const LatLng(-27.4705, 153.0260);

  //places Markers in list I don't actually know why this has to be an array but it makes it work.
  List<Marker> myMarker = [];

// Creates a Google map controller called controller and uses it as the map controller when the map is created.
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

// function that will add a marker at the position of the tappedPoint to myMarker[]
  _handleTap(LatLng tappedPoint) async {
    setState(() {
      myMarker = [];
      myMarker.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            child: GoogleMap(
              markers: Set.from(myMarker),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              onTap: _handleTap,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 10, right: 10),
            child: Material(
              child: Container(
                height: 30,
                child: TextField(
                  textAlignVertical: TextAlignVertical(y: 1.0),
                  autocorrect: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search Location',
                    hintTextDirection: TextDirection.ltr,
                  ),
                ),
              ),
            ),
          ),
          Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 50.0),
              child: Container(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Settings()),
                    );
                  },
                  child: const Icon(
                    Icons.menu,
                    size: 40,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
