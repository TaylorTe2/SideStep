import 'dart:ui';
import 'Vehicles.dart';

import 'package:flutter/material.dart';

int numVehiclesLoaded = -1;
int numVehiclesToLoad = -1;

class LoadSettings extends StatefulWidget {
  const LoadSettings({Key? key}) : super(key: key);

  @override
  State<LoadSettings> createState() => _LoadSettingsState();
}

class _LoadSettingsState extends State<LoadSettings> {
  @override
  Widget build(BuildContext context) {
    return Settings();
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    vehicles = newVehicles;
    numVehiclesLoaded = -1;
    print(numVehiclesLoaded.toString() +
        ' << NumVehiclesLoaded in USERSETTINGS.');
    print(vehicles);
    print('Above was UserSettings.dart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Container(
          color: Colors.grey[50],
          child: Column(
            children: [
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                color: Colors.orange[200],
                child: const Icon(
                  Icons.person,
                  size: 150,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: UserInfo(),
              ),
              Text(
                'Vehicles',
                textScaleFactor: 1.5,
              ),
              for (var vehicle in vehicles)
                if (numVehiclesLoaded < vehicles.length) LoadVehicles(),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      width: 100,
                      height: 25,
                      child: FloatingActionButton(
                        heroTag: 'add Vehicle',
                        isExtended: true,
                        onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const AddVehicle())))
                        },
                        child: Text('Add Vehicle'),
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: SizedBox(
                      width: 150,
                      height: 25,
                      child: FloatingActionButton(
                        heroTag: 'remove vehicle',
                        isExtended: true,
                        onPressed: () => {print('pressed remove vehicle')},
                        child: Text('Remove a Vehicle'),
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        backgroundColor: Colors.orange[900],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
          child: Text(
            'Your Info',
            textScaleFactor: 1.5,
            textAlign: TextAlign.left,
          ),
        ),
        // Here is the information inside of the white box underneath 'Your Info'. This will need
        // to be updated at a later date to be more dynamic. However, for now this will do just fine.
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width - 20,
          color: Colors.white,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Text('First Name', textScaleFactor: 1.2),
                  ),
                  Text('Darkroom'),
                  Text('________________________'),
                  Text('Location:   Brisbane', textScaleFactor: 1.2)
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text('Last Name', textScaleFactor: 1.2),
                    ),
                    Text('Developers'),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
