import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'communication.dart';
import 'list.dart';

Position userLocation;
Geolocator geolocator = Geolocator();
String MyBusId;

class GeoListenPage extends StatefulWidget {
  @override
  _GeoListenPageState createState() => _GeoListenPageState();
}

class _GeoListenPageState extends State<GeoListenPage> {

  @override
  void initState() {
    super.initState();
    _getLocation().then((position) {
      userLocation = position;
    });
    geolocator
        .getPositionStream(LocationOptions(
        accuracy: LocationAccuracy.best, timeInterval: 60000))
        .listen((position) {
      userLocation = position;
      print(userLocation);
      if(MyBusId != null){
        var post = {'BusId':MyBusId,'BusName': bus_list.singleWhere((o) => o.BusId == MyBusId, orElse: () => new Bus()).BusName,'Actual_Latitude':userLocation.latitude,'Actual_Longitude':userLocation.longitude};
        print(post);
        PostBusInformation(post);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var list = bus_list.map((var value) {
      return new DropdownMenuItem<String>(
        value: value.BusId,
        child: new Text(value.BusId),
      );
    }).toList();
    list.add( new DropdownMenuItem<String>(
      value: 'Off',
      child: new Text('Off'),
    ));
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            userLocation == null
                ? CircularProgressIndicator()
                : Text("Location:" +
                userLocation.latitude.toString() +
                " " +
                userLocation.longitude.toString()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  _getLocation().then((value) {
                    setState(() {
                      userLocation = value;
                    });
                  });
                },
                color: Colors.blue,
                child: Text(
                  "Get Location",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            MyBusId == null
                ? Text("Please select the bus you are traveling with:")
                : Text("Your bus is:" + MyBusId),
            new DropdownButton<String>(
              value: MyBusId == null ? 'Off' : MyBusId,
              items: list.reversed.toList(),
              onChanged: (newVal) {
                setState(() {
                  if(newVal == 'Off'){
                    MyBusId = null;
                  }else{
                    MyBusId = newVal;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}

String longitude(){
  return userLocation.longitude.toString();
}

String latitude(){
  return userLocation.latitude.toString();
}