import 'package:bus_project/models/Station.dart';
import 'package:bus_project/models/Timetable.dart';
import 'package:bus_project/screens/Shared/list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimetableScreen extends StatelessWidget {
  String busid;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  List<Timetable> actualTimetable1;
  List<Timetable> actualTimetable2;
  String firstid;

  TimetableScreen([String this.busid]);

/*
  @override
  void initState() {

  }*/

  @override
  Widget build(BuildContext context) {
    currentContext = context;
    actualTimetable1 = new List<Timetable>.from(timetable);
    actualTimetable1.retainWhere((Timetable t) {
      if (t.busNr == busid) {
        return true;
      } else {
        return false;
      }
    });
    firstid = actualTimetable1[0].stationID;
    actualTimetable2 = new List<Timetable>.from(actualTimetable1);
    actualTimetable1.retainWhere((Timetable t) {
      if (t.stationID == firstid) {
        return true;
      } else {
        return false;
      }
    });
    actualTimetable2.retainWhere((Timetable t) {
      if (t.stationID != firstid) {
        return true;
      } else {
        return false;
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Selected Bus: " + busid + " " + dateFormat.format(DateTime.now())),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
        Text(station_list.firstWhere((Station s) {
          if (s.StationId == actualTimetable1.elementAt(0).stationID)
            return true;
          return false;
        }).StationName),
        new Expanded(
            child: ListView.builder(
          itemCount: actualTimetable1.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(actualTimetable1.elementAt(index).startTime));
          },
        )),
        Text(station_list.firstWhere((Station s) {
          if (s.StationId == actualTimetable2.elementAt(0).stationID)
            return true;
          return false;
        }).StationName),
        new Expanded(
            child: ListView.builder(
                itemCount: actualTimetable2.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(actualTimetable2.elementAt(index).startTime));
                })),
      ])),
    );
  }
}
