import 'package:flutter/material.dart';
import 'package:bus_project/screens/Shared/list.dart';
import 'package:bus_project/screens/MapPage/maps.dart';
import 'package:bus_project/services/communication.dart';
import 'timetable.dart';

class Todo {
  String BusId;
  double Actual_Latitude;
  double Actual_Longitude;

  Todo(this.BusId, this.Actual_Latitude, this.Actual_Longitude);
}

class Buslist1 extends StatefulWidget {
  @override
  _BusListActionListener createState() => new _BusListActionListener();
}

class _BusListActionListener extends State<Buslist1> {
  //List<int> bus_name = list();
  //Map<int, String> _list_map = list_map();

  @override
  void initState() {
    super.initState();

    if (bus_list == null) {
      GetBusInformation().then((val) => setState(() {
            bus_list = val.BusList;
          }));
    }
    if (station_list == null) {
      GetStationsList().then((val) => station_list = val.StationList);
    }
    if (line_list == null) {
      GetLinesList().then((val) => setState(() {
            line_list = val.LineList;
          }));
    }
    if (timetable == null) {
      GetTimetable().then((val) => setState(() {
            timetable = val.TimetableList;
          }));
    }
    if (ServerClientDifference == null) {
      Syncronization().then((serverTime) {
        print(serverTime);
        ServerClientDifference = DateTime.now()
            .difference(serverTime); //I guess this doesn't need refresh so...
        print(ServerClientDifference);
      });
    }
    GeoPosition.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    currentContext = context;
    return bus_list == null
        ? Scaffold(
            body: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,

                    ///new
                    children: <Widget>[CircularProgressIndicator()])))
        : ListView.builder(
            itemCount: bus_list.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: new CircleAvatar(
                    child: new Text(bus_list.elementAt(index).BusId)),
                title: Text(bus_list.elementAt(index).BusName),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  print("Rovid gomb nyomas");
                  if (timetable != null) {
                    String busid = bus_list.elementAt(index).BusId;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimetableScreen(busid),
                      ),
                    );
                  }
                },
                onLongPress: () {
                  print("Hosszu gomb nyomas");
                  Todo coords = Todo(
                      bus_list.elementAt(index).BusId,
                      bus_list.elementAt(index).Actual_Latitude,
                      bus_list.elementAt(index).Actual_Longitude);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Maps(coords),
                    ),
                  );
                },
              );
            },
          );
  }
}
