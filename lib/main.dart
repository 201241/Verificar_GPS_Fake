import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:trust_location/trust_location.dart';

import 'package:location_permissions/location_permissions.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _latitude;
  String? _longitude;
  bool? _isMockLocation;

  Future<void> getLocation() async {
    try {
      TrustLocation.onChange.listen((values) => setState(() {
            _latitude = values.latitude;
            _longitude = values.longitude;
            _isMockLocation = values.isMockLocation;
          }));
    } on PlatformException catch (e) {
      print('PlatformException $e');
    }
  }

  void requestLocationPermission() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
    print('permissions: $permission');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Verificar gps'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Column(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: (_isMockLocation == false)
                    ? Colors.greenAccent
                    : Colors.red,
                child: Text(
                  (_isMockLocation == false) ? "True" : "Fake",
                  style: TextStyle(fontSize: 40),
                ),
                radius: 100,
              ),
              Text('Mock Location: $_isMockLocation'),
              Text('Latitude: $_latitude, Longitude: $_longitude'),
              ElevatedButton(
                  onPressed: () {
                    requestLocationPermission();
                    TrustLocation.start(1);
                    getLocation();
                    //TrustLocation.stop();
                  },
                  child: Text(
                    "Verificar",
                  )),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    requestLocationPermission();
                    TrustLocation.stop();
                  },
                  child: Text(
                    "Desactivar",
                  ))
            ],
          )),
        ),
      ),
    );
  }
}
