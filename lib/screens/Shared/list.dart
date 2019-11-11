import 'package:bus_project/models/BusInfo.dart';
import 'package:bus_project/models/Trace.dart';
import 'package:bus_project/services/ActivityRecognition.dart';
import 'package:bus_project/services/GPS.dart';
import 'package:flutter/cupertino.dart';
import 'package:bus_project/models/ArrivalTime.dart';
import 'package:bus_project/models/Bus.dart';
import 'package:bus_project/models/Line.dart';
import 'package:bus_project/models/Station.dart';
import 'package:bus_project/models/Timetable.dart';

List<Bus> bus_list;
List<BusInfo> businfo_list;
List<Station> station_list;
List<Line> line_list;
List<Trace> trace_list;
List<ArrivalTime> arrivaltime_list;
List<Timetable> timetable;
double range = 0.15; //0.15 0.03
int bus_list_size;
BuildContext currentContext;
ActivityRecognition DrivingDetector = ActivityRecognition();
GPS GeoPosition = GPS();

int next;
Line actualLine;
entry actualStation;
entry nextStation;
Stopwatch stopwatch;

Duration ServerClientDifference = null;
String stationText = "No sations nearby";
bool nearStation = false;
String MyBusId;
