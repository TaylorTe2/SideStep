import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sidestep/main.dart';
import 'dart:ui';
import 'dart:io';
import 'UserSettings.dart';
import 'package:path_provider/path_provider.dart';

List<List<dynamic>> vehicles = [];
List<List<dynamic>> newVehicles = [];

int numVehiclesInList = 0;

//gets the documents directory of device
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

//gets the exact file location of said device
Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/VehicleInfo.csv');
}

void writeCSV() async {
  final file = await _localFile;

  file.writeAsString(ListToCsvConverter().convert(vehicles));
}

void loadVehicleCSV() async {
  if (vehicles.length < 1) {
    final myVehicles = await _localFile;

    final myVehiclesString = await myVehicles.readAsString();
    List<List<dynamic>> csvTable =
        CsvToListConverter().convert(myVehiclesString);

    vehicles = csvTable;
  }
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
    super.initState();
    loadVehicleCSV();
    if (numVehiclesLoaded < (vehicles.length - 1)) numVehiclesLoaded++;
    print(numVehiclesLoaded);
    print(vehicles);
    print('Above was Vehicles.Dart');
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

// Add Vehicle Screen/Class Below this line.

class AddVehicle extends StatefulWidget {
  const AddVehicle({Key? key}) : super(key: key);

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Vehicle'),
      ),
      body: const AddVehicleForm(),
    );
  }
}

class AddVehicleForm extends StatefulWidget {
  const AddVehicleForm({Key? key}) : super(key: key);

  @override
  State<AddVehicleForm> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<AddVehicleForm> {
  final _addVehicleFormKey = GlobalKey<FormState>();
  String newMake = "";
  String newModel = "";
  double newFuelConsumption = 0;
  String newPlate = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addVehicleFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
            child: Text(
              'Vehicle Make',
              textScaleFactor: 1.15,
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter some text';
              }
              newMake = value;
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
            child: Text(
              'Vehicle Model',
              textScaleFactor: 1.15,
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter some text';
              }
              newModel = value;
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
            child: Text(
              'Fuel Consumption (L/100km)',
              textScaleFactor: 1.15,
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  double.tryParse(value) == null) {
                return 'Please Enter a number value, eg 6.4';
              }
              newFuelConsumption = double.parse(value);
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
            child: Text(
              'Licence Plate',
              textScaleFactor: 1.15,
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter some text';
              }
              newPlate = value;
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_addVehicleFormKey.currentState!.validate()) {
                //convert inputs to list eg [Toyota, Camry, 7.1, ABD223]
                List newVehicle = [
                  newMake,
                  newModel,
                  newFuelConsumption,
                  newPlate
                ];

                //append this list to vehicles[]
                newVehicles.add(newVehicle);
                print(newVehicles);
                print(vehicles);
                print('Above is after button is pressed.');

                //overwrite vehicleInfo.csv with vehicles[]
                writeCSV();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              }
            },
            child: const Text('Submit'),
          )
        ],
      ),
    );
  }
}
