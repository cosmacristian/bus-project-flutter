
import 'dart:async';

import 'package:activity_recognition_alt/activity_recognition_alt.dart';
import 'package:bus_project/services/ActivityRecognition.dart';
import 'package:bus_project/services/ActivityRecognition.dart';
import 'package:bus_project/services/ActivityRecognition.dart';
import 'package:bus_project/services/GPS.dart';
import 'package:bus_project/services/GPS.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bus_project/models/ArrivalTime.dart';
import 'package:bus_project/models/Bus.dart';
import 'package:bus_project/models/Line.dart';
import 'package:bus_project/models/Station.dart';
import 'package:bus_project/models/Timetable.dart';

List<Bus> bus_list;
List<Station> station_list;
List<Line> line_list;
List<ArrivalTime> arrivaltime_list;
List<Timetable> timetable;
double range = 0.15;//0.15 0.03
int bus_list_size;
BuildContext currentContext;
//bool questionSent = false;
ActivityRecognition DrivingDetector = ActivityRecognition();
GPS GeoPosition = GPS();

Line actualLine;
entry actualStation;
entry nextStation;
Stopwatch stopwatch;

Duration ServerClientDifference=null;

//Geolocator geolocator = Geolocator();
//Stream<Position> stream;
//Position userLocation;
String stationText = "No sations nearby";
//Stream<Activity> active;
//Activity userActivity;
//List<double> accelerometerValues;
//List<double> gyroscopeValues;
//List<double> userAccelerometerValues;

//List<StreamSubscription> streamSubscriptions;
bool nearStation=false;
//int DrivingScore=0;
//Timer DrivingCheck;
String MyBusId;
/*
Map<int, String> list_map(){
  Map<int, String> _list_bus_map;
  _list_bus_map = {
    27 : "Sapientia - Spitalul Judetean",
    44 : "Sapientia - Combinat",
    4 : "Combinat - Aleea Carpati",
    26 : "Sapientia - Aleea Carpati",
    20 : "Centrofarm - Spaital Judetean"
  };
  return _list_bus_map;
}

int list_size(){
  var list_bus = list();
  return list_bus.length;
}
List<int> list(){
  final List<int> _listBus = [
    26,27,44,4,20
  ];
  return _listBus;
}*/