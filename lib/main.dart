import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-27.4705, 153.0260);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              myLocationButtonEnabled: true,
              compassEnabled: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 35.0),
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
        ],
      ),
    );
  }
}
