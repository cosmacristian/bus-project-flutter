import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:bus_project/screens/Shared/list.dart';
import 'package:bus_project/models/Line.dart';
import 'buses.dart';

class settings {
  LocationAccuracy ac;
  String tm = '';
  String di = '';
  String sr = '';
}

class GeoListenPage extends StatefulWidget {
  @override
  _GeoListenPageState createState() => _GeoListenPageState();
}

class _GeoListenPageState extends State<GeoListenPage> {
  bool condition = false;
  Timer Refresh;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  settings newSettings = new settings();

  @override
  void initState() {
    super.initState();
    condition = false;
    Timer.periodic(Duration(seconds: 2), (Refresh) {
      if (condition) {
        Refresh.cancel();
      } else {
        setState(() {});
      }
    });
    GeoPosition.getLocation();
  }

  void dispose() {
    condition = true;
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
        GeoPosition.accuracy = newSettings.ac;
        GeoPosition.timeInt = int.parse(newSettings.tm);
        GeoPosition.distance = int.parse(newSettings.di);
        range = (int.parse(newSettings.sr) / 1000.toDouble());
        //state.didChange(newValue); ////////////
      });
    }
  }

  //Don't know what this is...
  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
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
    currentContext = context;
    var list = bus_list.map((var value) {
      return new DropdownMenuItem<String>(
        value: value.BusId,
        child: new Text(value.BusId),
      );
    }).toList();
    list.add(new DropdownMenuItem<String>(
      value: 'Off',
      child: new Text('Off'),
    ));
    return /*Scaffold(
            body: Center(
                child:*/
        LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GeoPosition.userLocation == null
                    ? CircularProgressIndicator()
                    : Text("Location:" +
                        GeoPosition.userLocation.latitude.toString() +
                        " " +
                        GeoPosition.userLocation.longitude.toString()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (arrivaltime_list != null &&
                          arrivaltime_list.length > 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusesScreen(),
                          ),
                        );
                      } else {
                        _showDialog(
                            "No station nearby!",
                            "You need to be at most " +
                                (range * 1000).toString() +
                                " meters away from a station to check for buses.");
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
                DrivingDetector.userActivity == null
                    ? CircularProgressIndicator()
                    : Text(
                        "Your phone is to ${DrivingDetector.userActivity.confidence}% ${DrivingDetector.userActivity.type}! Driving Score= ${DrivingDetector.DrivingScore}"),
                MyBusId == null
                    ? Text("Please select the bus you are traveling with:")
                    : Text("Your bus is:" + MyBusId),
                new DropdownButton<String>(
                  value: MyBusId == null ? 'Off' : MyBusId,
                  items: list.reversed.toList(),
                  onChanged: (newVal) {
                    setState(() {
                      if (newVal == 'Off') {
                        MyBusId = null;
                        nextStation = null;
                        actualStation = null;
                        actualLine = null;
                        DrivingDetector.pauseDrivingDetection();
                      } else {
                        MyBusId = newVal;
                        actualLine = line_list.firstWhere((Line l) {
                          return l.LineID.toString() == newVal;
                        });
                        DrivingDetector.startDrivingDetection();
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
                        value: GeoPosition.accuracy,
                        items: [
                          DropdownMenuItem<LocationAccuracy>(
                              value: LocationAccuracy.bestForNavigation,
                              child: new Text("Best accuracy")),
                          DropdownMenuItem<LocationAccuracy>(
                              value: LocationAccuracy.high,
                              child: new Text("High accuracy")),
                          DropdownMenuItem<LocationAccuracy>(
                              value: LocationAccuracy.medium,
                              child: new Text("Medium accuracy")),
                          DropdownMenuItem<LocationAccuracy>(
                              value: LocationAccuracy.low,
                              child: new Text("Low accuracy")),
                          DropdownMenuItem<LocationAccuracy>(
                              value: LocationAccuracy.lowest,
                              child: new Text("Lowest accuracy")),
                        ],
                        onChanged: (LocationAccuracy newValue) {
                          //print("Changed");
                          setState(() {
                            //print(newValue.toString());
                            newSettings.ac = newValue;
                            GeoPosition.accuracy = newValue;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: new InputDecoration(
                            labelText: "Interval in seconds"),
                        //controller: IntervalController,
                        keyboardType: TextInputType.number,
                        initialValue: GeoPosition.timeInt.toString(),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'If you want to save the settings you must provide information.';
                          }
                          return null;
                        },
                        onSaved: (val) => newSettings.tm = val,
                      ),
                      TextFormField(
                        decoration: new InputDecoration(
                            labelText: "Distance in meters"),
                        //controller: DistanceController,
                        keyboardType: TextInputType.number,
                        initialValue: GeoPosition.distance.toString(),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'If you want to save the settings you must provide information.';
                          }
                          return null;
                        },
                        onSaved: (val) => newSettings.di = val,
                      ),
                      TextFormField(
                        decoration: new InputDecoration(
                            labelText: "Station detection distance in meters"),
                        //controller: DistanceController,
                        keyboardType: TextInputType.number,
                        initialValue: (range * 1000).toString(),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'If you want to save the settings you must provide information.';
                          }
                          return null;
                        },
                        onSaved: (val) => newSettings.sr = val,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          onPressed: _submitForm,
                          /*() {
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
      },
    );
    /*),
        );*/
  }
}