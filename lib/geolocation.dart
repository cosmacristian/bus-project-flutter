import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'dart:async';
import 'communication.dart';
import 'list.dart';
import 'package:sensors/sensors.dart';
import 'package:activity_recognition_alt/activity_recognition_alt.dart';

Activity userActivity;
Position userLocation;
List<double> _accelerometerValues;
List<double> _gyroscopeValues;
List<double> _userAccelerometerValues;

Geolocator geolocator = Geolocator();
String MyBusId;
String stationText = "No sations nearby";
Stream<Position> stream;
Stream<Activity> active;
LocationAccuracy accuracy = LocationAccuracy.bestForNavigation;
int timeInt = 30000;
int distance = 2;
List<StreamSubscription> _streamSubscriptions;
bool nearStation=false;


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
    bool condition=false;
    Timer Refresh;
    final _formKey = GlobalKey<FormState>();
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    settings newSettings = new settings();

    //final IntervalController = TextEditingController();
    //final DistanceController = TextEditingController();
    //final AccuracyController = Dropdown

    @override
    void initState() {
        super.initState();
        condition=false;
        Timer.periodic(Duration(seconds: 2),(Refresh) {
            if(condition){
                Refresh.cancel();
            }else {
                setState(() {

                });
            }
        });
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
        if(active == null){
          active = ActivityRecognitionAlt.activityUpdates();
          active.listen((action){
            userActivity = action;
            print("Your phone is to ${action.confidence}% ${action.type}!");
            //setState(() {
            //  userActivity = action;
            //});
          });
        }
        if(stream == null) {
            stream = geolocator
                .getPositionStream(LocationOptions(
                accuracy: accuracy, timeInterval: timeInt, distanceFilter: distance));
            stream.listen((position) {
                userLocation = position;
                //print(userLocation);
                //print(ServerClientDifference);
                List<Station> nearbyStations = new List<Station>.from(station_list);
                if(nearStation == false) {
                  bool detected = false;
                  nearbyStations.retainWhere((Station s) {
                    double dist = distanceInKmBetweenEarthCoordinates(
                        userLocation.latitude, userLocation.longitude,
                        s.Latitude, s.Longitude);
                    print(s.StationName + " dist = " + dist.toString() + " km");
                    if (dist <= 0.03/*0.150.02*/) { //Distance between two coordinates.
                      print(s.StationName + " is the closest dist = " +
                          dist.toString() + " km");
                      detected = true;
                      return true;
                    }
                    return false;
                  });
                  if(detected){
                    nearStation=true;
                    stationText = "You are at: "+nearbyStations.first.StationName;
                    GetTimeList(int.parse(nearbyStations.first.StationId)).then((val) =>
                    arrivaltime_list = val.ArrivalTimeList
                    );
                  }else{
                    nearStation=false;
                    stationText = "No sations nearby";
                    if(arrivaltime_list != null && arrivaltime_list.length > 0)
                    arrivaltime_list.clear();
                  }
                }
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
                    //print(post);
                    PostBusInformationTest(post);
                }
            });
        }
    }

    void dispose() {
        condition=true;
        super.dispose();
    }

    void _submitForm() {
        final FormState form = _formKey.currentState;

        if (!form.validate()) {
            showMessage('Form is not valid!  Please review and correct.');
        } else {
            form.save(); //This invokes each onSaved event

            //print('Form save called, newSettings is now up to date...');
            //print('accuracy: ${newSettings.ac}');
            //print('distance: ${newSettings.di}');
            //print('timeInt: ${newSettings.tm}');

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

    void _showDialog(String Title, String Message) {
        // flutter defined function
        showDialog(
            context: context,
            builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                    title: new Text(Title),
                    content: new Text(Message),
                    actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                            child: new Text("Close"),
                            onPressed: () {
                                Navigator.of(context).pop();
                            },
                        ),
                    ],
                );
            },
        );
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
                                    if(arrivaltime_list != null && arrivaltime_list.length > 0) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BusesScreen(),
                                            ),
                                        );
                                    }else{
                                        _showDialog("No station nearby!","You need to be at most 30 meters close from a station to check for buses.");
                                    }
                                },
                                color: Colors.blue,
                                child: Text(
                                    "Show buses",
                                    style: TextStyle(color: Colors.white),
                                ),
                            ),
                        ),
                        Text(stationText),
                        userActivity == null
                            ? CircularProgressIndicator()
                            : Text("Your phone is to ${userActivity.confidence}% ${userActivity.type}!"),
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
                                            //print("Changed");
                                            setState(() {
                                                //print(newValue.toString());
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

double degreesToRadians(degrees) {
  return degrees * PI / 180;
}

double distanceInKmBetweenEarthCoordinates(lat1, lon1, lat2, lon2) {
  var earthRadiusKm = 6371;

  var dLat = degreesToRadians(lat2-lat1);
  var dLon = degreesToRadians(lon2-lon1);

  lat1 = degreesToRadians(lat1);
  lat2 = degreesToRadians(lat2);

  var a = sin(dLat/2) * sin(dLat/2) +
      sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2);
  var c = 2 * atan2(sqrt(a), sqrt(1-a));
  return earthRadiusKm * c;
}


class BusesScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Incomming Buses"),
            ),
            body: Center(
                child: ListView.builder(
                    itemCount: bus_list.length,
                    itemBuilder: (context, index){
                        return ListTile(
                            leading: new CircleAvatar(child: new Text(arrivaltime_list.elementAt(index).busID)),
                            title: Text(arrivaltime_list.elementAt(index).toString())
                        );
                    }
                )
            ),

        );
    }
}

