import 'package:bus_project/models/Station.dart';
import 'package:bus_project/models/Timetable.dart';
import 'package:bus_project/screens/Shared/list.dart';
import 'package:bus_project/services/AppLocalizations.dart';
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
    List<Widget> list1 = List();
    actualTimetable1.forEach((Timetable t){
      list1.add(new Padding(padding: new EdgeInsets.all(20.0),
          child: new Text(
              t.startTime,
              style: new TextStyle(fontSize: 25.0)
          )));
    });
    List<Widget> list2 = List();
    actualTimetable2.forEach((Timetable t){
      list2.add(new Padding(padding: new EdgeInsets.all(20.0),
          child: new Text(
              t.startTime,
              style: new TextStyle(fontSize: 25.0)
          )));
    });
    return Scaffold(
        appBar: AppBar(
          title: Text(
              AppLocalizations.of(context).translate('timetable_title') +
                  busid +
                  " " +
                  dateFormat.format(DateTime.now())),
        ),
        body: //CustomScrollView( slivers: <Widget>[
        Row(
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(station_list.firstWhere((Station s) {
                  if (s.StationId == actualTimetable1.elementAt(0).stationID)
                    return true;
                  return false;
                }).StationName,
                style: new TextStyle(fontSize: 20.0)),
                new Container(
                    height: 500.0,
                    width: 180.0,
                    child:
                CustomScrollView(
                    slivers: <Widget>[SliverList(delegate: new SliverChildListDelegate(list1))])),
              ]),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(station_list.firstWhere((Station s) {
                  if (s.StationId == actualTimetable2.elementAt(0).stationID)
                    return true;
                  return false;
                }).StationName,
                style: new TextStyle(fontSize: 20.0)),
                new Container(
                    height: 500.0,
                    width: 180.0,
                    child:
                CustomScrollView(
                    slivers: <Widget>[SliverList(delegate: new SliverChildListDelegate(list2))])),
              ]),
        ]));
  }
}
