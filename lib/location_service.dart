import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'secrets.dart';

class LocationService {
  final String key = Secrets.API_KEY;

  Future<String> getPlaceId(String input) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;

    //print(placeId);

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    //print(results);
    return results;
  }

  Future<Map<String, dynamic>> getDirections(
      String orgin, String destination) async {
    String fastest =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$orgin&destination=$destination&key=$key';
    String noToll =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$orgin&destination=$destination&avoid=tolls&key=$key';

    var responseFastest = await http.get(Uri.parse(fastest));
    var responsenoToll = await http.get(Uri.parse(noToll));
    var jsonFastest = convert.jsonDecode(responseFastest.body);
    var jsonNoToll = convert.jsonDecode(responsenoToll.body);

    // Calculate Flexible

    //Halfway point
    var _midPoint = jsonNoToll['routes'][0]['legs'][0]['distance']['value'] / 2;

    double _flexiLat = 0;
    double _flexiLng = 0;

    //Find which step crosses halfway point
    for (var i = 0; 1 <= _midPoint; i++) {
      _midPoint = _midPoint -
          jsonNoToll['routes'][0]['legs'][0]['steps'][i]['distance']['value'];
      if (_midPoint <= 0) {
        print("Found MidPOINT");
        _flexiLat = jsonNoToll['routes'][0]['legs'][0]['steps'][i]
            ['end_location']['lat'];
        _flexiLng = jsonNoToll['routes'][0]['legs'][0]['steps'][i]
            ['end_location']['lng'];
      }
    }

    print("Build URLS");
    String flexi1 =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$orgin&destination=$_flexiLat,$_flexiLng&avoid=tolls&key=$key';
    String flexi2 =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$_flexiLat,$_flexiLng&destination=$destination&key=$key';

    print(flexi2);

    var responseflexi1 = await http.get(Uri.parse(flexi1));
    var responseflexi2 = await http.get(Uri.parse(flexi2));
    var jsonFlexi1 = convert.jsonDecode(responseflexi1.body);
    var jsonFlexi2 = convert.jsonDecode(responseflexi2.body);

    print("JSON GOOD!");

    var results = {
      'bounds_ne': jsonFastest['routes'][0]['bounds']['northeast'],
      'bounds_sw': jsonFastest['routes'][0]['bounds']['southwest'],
      'start_location': jsonFastest['routes'][0]['legs'][0]['start_location'],
      'end_location': jsonFastest['routes'][0]['legs'][0]['end_location'],
      'polyline': jsonFastest['routes'][0]['overview_polyline']['points'],
      'polyline_decoded_fastest': PolylinePoints().decodePolyline(
          jsonFastest['routes'][0]['overview_polyline']['points']),
      'polyline_decoded_noToll': PolylinePoints().decodePolyline(
          jsonNoToll['routes'][0]['overview_polyline']['points']),
      'polyline_decoded_flexi1': PolylinePoints().decodePolyline(
          jsonFlexi1['routes'][0]['overview_polyline']['points']),
      'polyline_decoded_flexi2': PolylinePoints().decodePolyline(
          jsonFlexi2['routes'][0]['overview_polyline']['points']),
    };
    print("results sent!");
    return results;
  }
}
