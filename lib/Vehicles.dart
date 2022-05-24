import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

List<List<dynamic>> vehicles = [];
int numVehiclesLoaded = -1;

void loadVehicleCSV() async {
  final myVehicles = await rootBundle.loadString('assets/VehicleInfo.csv');
  List<List<dynamic>> csvTable = CsvToListConverter().convert(myVehicles);

  vehicles = csvTable;
  print(vehicles);
}

class LoadVehicles extends StatefulWidget {
  const LoadVehicles({Key? key}) : super(key: key);

  @override
  State<LoadVehicles> createState() => _LoadVehiclesState();
}

class _LoadVehiclesState extends State<LoadVehicles> {
  @override
  void initState() {
    loadVehicleCSV();
    numVehiclesLoaded++;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          width: MediaQuery.of(context).size.width - 20,
          height: 50,
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
              //Make Section for each widget built
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Container(
                  width: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Make:', textScaleFactor: 1.1),
                      Text(vehicles[numVehiclesLoaded][0])
                    ],
                  ),
                ),
              ),
              // Model Section for each widget built
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Container(
                  width: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Model:', textScaleFactor: 1.1),
                      Text(vehicles[numVehiclesLoaded][1])
                    ],
                  ),
                ),
              ),
              //Fuel Economy UI Section for each widget built
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Container(
                  width: 65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fuel Eco:', textScaleFactor: 1.1),
                      //LOOK HERE FOR ECO FURL
                      Text(vehicles[numVehiclesLoaded][2].toString())
                    ],
                  ),
                ),
              ),
              // Plate Section for each widget built.
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Plate:', textScaleFactor: 1.1),
                    Text(vehicles[numVehiclesLoaded][3]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add Vehicle Class Below this line.

class AddVehicle extends StatefulWidget {
  const AddVehicle({Key? key}) : super(key: key);

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
