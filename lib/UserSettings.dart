import 'dart:ui';

import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

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
              MyVehiclesButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyVehiclesButton extends StatelessWidget {
  const MyVehiclesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.car_rental,
              size: 40,
            ),
            Center(
              child: Text(
                'My Vehicles',
                textAlign: TextAlign.center,
                textScaleFactor: 1.1,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        print("tapped");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserVehicles()),
        );
      },
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
        Container(
          //User info goes here.

          height: 100,
          width: MediaQuery.of(context).size.width - 20,
          color: Colors.white,
        )
      ],
    );
  }
}

class UserVehicles extends StatelessWidget {
  const UserVehicles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Vehicles'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Container(
            height: 180.0,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Center(
              child: Text(
                'Vehicle information placeholder',
                textAlign: TextAlign.center,
                textScaleFactor: 1.1,
              ),
            ),
          )
        ],
      ),
    );
  }
}
