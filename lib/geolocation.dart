import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'communication.dart';
import 'list.dart';
import 'package:sensors/sensors.dart';

Position userLocation;
List<double> _accelerometerValues;
List<double> _gyroscopeValues;
List<double> _userAccelerometerValues;

Geolocator geolocator = Geolocator();
String MyBusId;
Stream<Position> stream;
LocationAccuracy accuracy = LocationAccuracy.bestForNavigation;
int timeInt = 30000;
int distance = 2;
List<StreamSubscription> _streamSubscriptions;
class settings {
  LocationAccuracy ac;
  String tm = '';
  String di = '';
}

class GeoListenPage extends StatefulWidget {
  @override
  _GeoListenPageState createState() => _GeoListenPageState();
}

class _GeoListenPageState extends State<GeoListenPage> {


  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  settings newSettings = new settings();

  //final IntervalController = TextEditingController();
  //final DistanceController = TextEditingController();
  //final AccuracyController = Dropdown

  @override
  void initState() {
    super.initState();
    _getLocation().then((position) {   /// Ha facebook akkor nem megy | youtube sem megy | ha lezarodik akkor nem biztos...
      userLocation = position;
    });
    if(_streamSubscriptions == null || _streamSubscriptions.length > 3) {
      _streamSubscriptions = List<StreamSubscription>();
      _streamSubscriptions
          .add(accelerometerEvents.listen((AccelerometerEvent event) {
          _accelerometerValues = <double>[event.x, event.y, event.z];
          //print("ACCELEROMETER: x="+event.x.toString()+" y="+event.y.toString()+" z="+event.z.toString());
      }));
      _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
          _gyroscopeValues = <double>[event.x, event.y, event.z];
          //print("GYROSCOPE: x="+event.x.toString()+" y="+event.y.toString()+" z="+event.z.toString());
      }));
      _streamSubscriptions
          .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
          _userAccelerometerValues = <double>[event.x, event.y, event.z];
          //print("USER ACCELEROMETER: x="+event.x.toString()+" y="+event.y.toString()+" z="+event.z.toString());
      }));
    }
    if(stream == null) {
      stream = geolocator
          .getPositionStream(LocationOptions(
          accuracy: accuracy, timeInterval: timeInt, distanceFilter: distance));
      stream.listen((position) {
        userLocation = position;
        print(userLocation);
        print(ServerClientDifference);
        if (MyBusId != null) {
          var post = {
            'BusId': MyBusId,
            'BusName': bus_list
                .singleWhere((o) => o.BusId == MyBusId, orElse: () => new Bus())
                .BusName,
            'Actual_Latitude': userLocation.latitude,
            'Actual_Longitude': userLocation.longitude,
            'Position_Accuracy': userLocation.accuracy,
            'Actual_Speed': userLocation.speed,
            'Speed_Accuracy': userLocation.speedAccuracy,
            'Direction': userLocation.heading,
            'Acceleration': _accelerometerValues,
            'Gyroscope': _gyroscopeValues,
            'Timestamp': DateTime.now().add(ServerClientDifference).toString().split(".")[0]
          };
          print(post);
          PostBusInformationTest(post);
        }
      });
    }
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event

      print('Form save called, newSettings is now up to date...');
      print('accuracy: ${newSettings.ac}');
      print('distance: ${newSettings.di}');
      print('timeInt: ${newSettings.tm}');

      setState(() {
        accuracy = newSettings.ac;
        timeInt = int.parse(newSettings.tm) ;
        distance = int.parse(newSettings.di) ;
        //state.didChange(newValue); ////////////
      });

    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
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
            Form(
              key: _formKey,
              autovalidate: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  DropdownButton<LocationAccuracy>(
                    value: accuracy,
                    items: [
                      DropdownMenuItem<LocationAccuracy>(value: LocationAccuracy.bestForNavigation,child: new Text("Best accuracy")),
                      DropdownMenuItem<LocationAccuracy>(value: LocationAccuracy.high,child: new Text("High accuracy")),
                      DropdownMenuItem<LocationAccuracy>(value: LocationAccuracy.medium,child: new Text("Medium accuracy")),
                      DropdownMenuItem<LocationAccuracy>(value: LocationAccuracy.low,child: new Text("Low accuracy")),
                      DropdownMenuItem<LocationAccuracy>(value: LocationAccuracy.lowest,child: new Text("Lowest accuracy")),
                    ],
                    onChanged: (LocationAccuracy newValue) {
                      print("Changed");
                        setState(() {
                          print(newValue.toString());
                          newSettings.ac = newValue;
                          accuracy= newValue;
                        });
                    },
                  ),
                  TextFormField(
                    decoration: new InputDecoration(labelText: "Interval in seconds"),
                    //controller: IntervalController,
                    keyboardType: TextInputType.number,
                    initialValue: timeInt.toString(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'If you want to save the settings you must provide information.';
                      }
                      return null;
                    },
                    onSaved: (val) => newSettings.tm = val,
                  ),
                  TextFormField(
                    decoration: new InputDecoration(labelText: "Distance in meters"),
                    //controller: DistanceController,
                    keyboardType: TextInputType.number,
                    initialValue: distance.toString(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'If you want to save the settings you must provide information.';
                      }
                      return null;
                    },
                    onSaved: (val) => newSettings.di = val,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: _submitForm,/*() {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                          if (_formKey.currentState.validate()) {
                            //distance=DistanceController.text as int;
                            //timeInt=IntervalController.text as int;

                          }
                        },*/
                      child: Text('Save Settings'),
                    ),
                  ),
                ],
              ),
            )
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