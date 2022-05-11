import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class LoadVehicles extends StatefulWidget {
  const LoadVehicles({Key? key}) : super(key: key);

  @override
  State<LoadVehicles> createState() => _LoadVehiclesState();
}

class _LoadVehiclesState extends State<LoadVehicles> {
  List<List<dynamic>> vehicles = [];

  void loadVehicleCSV() async {
    final myVehicles = await rootBundle.loadString('VehicleInfo.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myVehicles);

    vehicles = csvTable;
  }

  @override
  void initState() {
    loadVehicleCSV();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        width: MediaQuery.of(context).size.width - 20,
        height: 100,
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: 50,
                  child: Icon(
                    Icons.car_rental,
                    size: 40,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Make:', textScaleFactor: 1.1),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Model:', textScaleFactor: 1.1),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fuel Eco:', textScaleFactor: 1.1),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Plate:', textScaleFactor: 1.1),
                  Text('test'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
