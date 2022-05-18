import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'UserSettings.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'secrets.dart';
import 'Vehicles.dart';
import 'location_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SideStep',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MapView(),
    );
  }
}

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  //Alex Vars
  Completer<GoogleMapController> _controller = Completer();

  //Text Input Controllers
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  // Sets / Lists containing map elements
  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polyline = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  // Used to provide unique names for polyline segments
  int _polygonIdCounter = 0;
  int _polylineIdCounter = 0;

  // Map Starting Location (Brisbane)
  static final CameraPosition _mainLocation =
      CameraPosition(target: LatLng(-27.4705, 153.0260), zoom: 14.4746);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    loadVehicleCSV();

    _setMarker(LatLng(-27.4705, 153.0260));
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(markerId: MarkerId('marker'), position: point),
      );
    });
  }

  void _setPolyline(
      List<PointLatLng> pointsFastest,
      List<PointLatLng> pointsNoTolls,
      List<PointLatLng> pointsFlexi1,
      List<PointLatLng> pointsFlexi2) {
    //Fastest Route
    final String polylineIdValFastest = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polyline.add(Polyline(
      polylineId: PolylineId(polylineIdValFastest),
      width: 6,
      color: Color.fromARGB(255, 0, 255, 42),
      points: pointsFastest
          .map(
            (point) => LatLng(point.latitude, point.longitude),
          )
          .toList(),
    ));

    //No Tolls
    final String polylineIdValNoToll = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polyline.add(Polyline(
      polylineId: PolylineId(polylineIdValNoToll),
      width: 5,
      color: Color.fromARGB(255, 1, 97, 240),
      points: pointsNoTolls
          .map(
            (point) => LatLng(point.latitude, point.longitude),
          )
          .toList(),
    ));

    //Flexi 1
    final String polylineIdValFlexi1 = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polyline.add(Polyline(
      polylineId: PolylineId(polylineIdValFlexi1),
      width: 4,
      color: Color.fromARGB(255, 252, 71, 0),
      points: pointsFlexi1
          .map(
            (point) => LatLng(point.latitude, point.longitude),
          )
          .toList(),
    ));

    //Flexi 2
    final String polylineIdValFlexi2 = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polyline.add(Polyline(
      polylineId: PolylineId(polylineIdValFlexi2),
      width: 4,
      color: Color.fromARGB(255, 252, 71, 0),
      points: pointsFlexi2
          .map(
            (point) => LatLng(point.latitude, point.longitude),
          )
          .toList(),
    ));
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent));
  }
  //End Alexs Vars

  //default starting position on map when the app is run. We should change this to device location in the future.
  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(-27.4705, 153.0260), zoom: 15.0);
  // Creates a Google map controller called controller and uses it as the map controller when the map is created.
  late GoogleMapController mapController;

  late Position _currentPosition;
  String _currentAddress = '';

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final destinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _destinationAddress = '';
  String? _placeDistance;

  Set<Marker> markers = {};

  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required double width,
    required Icon prefixIcon,
    Widget? suffixIcon,
    required Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.amber.shade400,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  //Method to get current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getaddress();
      //exception handling
    }).catchError((e) {
      print(e);
    });
  }

  //Method for retrieving address
  _getaddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  //Method for calculating distiance between 2 places
  Future<bool> _calculateDistance() async {
    //Wrapped everything in a try statement incase it doesnt work
    try {
      List<Location> startPlacemark = await locationFromAddress(_startAddress);
      List<Location> destinationPlacemark =
          await locationFromAddress(_destinationAddress);

      //uses this if routing is from users current position as its more accurate
      double startLatitude = _startAddress == _currentAddress
          ? _currentPosition.latitude
          : startPlacemark[0].latitude;

      double startLongitude = _startAddress == _currentAddress
          ? _currentPosition.longitude
          : startPlacemark[0].latitude;

      double destinationLatitude = destinationPlacemark[0].latitude;
      double destinationLongitude = destinationPlacemark[0].longitude;

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString =
          '($destinationLatitude, $destinationLongitude)';

      //Location marker at Start of route
      Marker startMarker = Marker(
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(startLatitude, startLongitude),
        infoWindow: InfoWindow(
          title: 'Start $startCoordinatesString',
          snippet: _startAddress,
        ),
        //Change start icon here!!!
        icon: BitmapDescriptor.defaultMarker,
      );

      //Location marker for destination
      Marker destinationMarker = Marker(
        markerId: MarkerId(destinationCoordinatesString),
        position: LatLng(destinationLatitude, destinationLongitude),
        infoWindow: InfoWindow(
          title: 'Destination $destinationCoordinatesString',
          snippet: _destinationAddress,
        ),
        //Change Destination Marker Here!!!
        icon: BitmapDescriptor.defaultMarker,
      );

      //Adds Markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      print(
        'START COORDINATES: ($startLatitude, $startLongitude)',
      );
      print(
        'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
      );
    } catch (e) {
      print(e);
    }
    return false;
  }

  // //Polylines
  // _createPolylines(
  //   double startLatitude,
  //   double startLongitude,
  //   double destinationLatitude,
  //   double destinationLongitude,
  // ) async {
  //   polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     Secrets.API_KEY,
  //     PointLatLng(startLatitude, startLongitude),
  //     PointLatLng(destinationLatitude, destinationLongitude),
  //     travelMode: TravelMode.driving,
  //   );

  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   }

  //   PolylineId id = PolylineId('poly');
  //   Polyline polyline = Polyline(
  //     polylineId: id,
  //     color: Colors.green.shade600,
  //     points: polylineCoordinates,
  //     width: 3,
  //   );
  //   polylines[id] = polyline;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _getCurrentLocation();
  //   loadVehicleCSV();
  // }

  @override
  Widget build(BuildContext context) {
    //these 2 lines adjust the size of the app as the user changes orientation on their phone
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    //returning container allows the above to take affect
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              markers: _markers,
              polygons: _polygons,
              polylines: _polyline,
              initialCameraPosition: _mainLocation,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                controller.setMapStyle(Secrets.mapStyle);
              },
            ),
            //Address input fields at top of screen
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Places',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 10),
                          _textField(
                              label: 'Start',
                              hint: 'Choose Starting Address',
                              prefixIcon: Icon(Icons.looks_one),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.my_location_rounded),
                                //Stores User entered info to be used with routing
                                onPressed: () {
                                  startAddressController.text = _currentAddress;
                                  _startAddress = _currentAddress;
                                },
                              ),
                              controller: _originController,
                              focusNode: startAddressFocusNode,
                              width: width,
                              locationCallback: (String value) {
                                setState(() {
                                  _startAddress = value;
                                });
                              }),
                          SizedBox(height: 10),
                          _textField(
                              label: 'Destination',
                              hint: 'Choose destination',
                              prefixIcon: Icon(Icons.looks_two),
                              controller: _destinationController,
                              focusNode: destinationAddressFocusNode,
                              width: width,
                              locationCallback: (String value) {
                                setState(() {
                                  _destinationAddress = value;
                                });
                              }),
                          SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: (() async {
                              //remove existing polylines
                              _polyline.clear();
                              var directions = await LocationService()
                                  .getDirections(_originController.text,
                                      _destinationController.text);
                              _goToPlace(
                                directions['start_location']['lat'],
                                directions['start_location']['lng'],
                                directions['bounds_ne'],
                                directions['bounds_sw'],
                              );

                              _setPolyline(
                                  directions['polyline_decoded_fastest'],
                                  directions['polyline_decoded_noToll'],
                                  directions['polyline_decoded_flexi1'],
                                  directions['polyline_decoded_flexi2']);
                            }),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Show Routing Options',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //Adds a 'Show Location' Button
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange.shade200,
                      child: InkWell(
                        splashColor: Colors.orange.shade400,
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.my_location),
                        ),
                        //Functionality for 'Show Location' Button
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                                zoom: 15.0,
                              ),
                            ),
                          );
                        },
                      ),
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
                        MaterialPageRoute(
                            builder: (context) => const Settings()),
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
      ),
    );
  }

  Future<void> _goToPlace(double lat, double lng, Map<String, dynamic> boundsNe,
      Map<String, dynamic> boundsSw) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));

    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng'])),
        25));

    _setMarker(LatLng(lat, lng));
  }
}
