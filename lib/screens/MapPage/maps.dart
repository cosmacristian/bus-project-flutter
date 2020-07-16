import 'dart:async';
import 'package:bus_project/models/Line.dart';
import 'package:bus_project/models/Station.dart';
import 'package:bus_project/models/Timetable.dart';
import 'package:bus_project/models/Trace.dart';
import 'package:bus_project/screens/Shared/start.dart';
import 'package:bus_project/services/AppLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:bus_project/screens/BusListPage/bus_list.dart';
import 'package:bus_project/services/communication.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../Shared/list.dart';
import 'package:flutter/scheduler.dart';

import 'package:bus_project/models/Bus.dart';

class Maps extends StatefulWidget {
  Todo todo;

  @override
  Maps_flutter createState() => new Maps_flutter(todo);

  Maps([Todo this.todo = null]);
}

class Maps_flutter extends State<Maps> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Todo todo;
  List<Marker> markers;
  List<Polyline> polylines;
  List<CircleMarker> circleMarkers;
  Timer _timer;
  MapController mapController;
  int selectedLayer = 0;
  bool toggleBus = true;
  bool toggleStation = false;
  bool toggleLine = false;
  String selectedBusId = "Off";


  Maps_flutter([Todo this.todo = null]);

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    GeoPosition.getLocation();
    if (todo != null)
      SchedulerBinding.instance.addPostFrameCallback((_) => _animatedMapMove(
          LatLng(todo.Actual_Latitude, todo.Actual_Longitude), 17.0));

    if (circleMarkers == null) circleMarkers = List<CircleMarker>();
  }

  LayerOptions FilterStations() {
    Color col = Colors.blue;
    bool blue = true;
    bool notfirst= false;
    Line line;
    List<String> stations;
    List<String> endlines;
    List<Station> filtered;
    if(selectedBusId != "Off") {
      if (line_list != null) {
        line =
            line_list.singleWhere((o) => o.LineID == selectedBusId,
                orElse: () => null);
        if (line != null && line.Stations.length != 0) {
          List<Timetable> tt = timetable.where((o) => o.busNr == selectedBusId).toList();
          endlines = tt.map((table) {
            return table.stationID;
          }).toList();
          filtered = line.Stations.map((entry) {
            return station_list.firstWhere((st){return st.StationId == entry.StationID.toString();});
          }).toList();

          /*
          stations = line.Stations.map((entry) {
            return entry.StationID.toString();
          }).toList();

          filtered = new List<Station>.from(station_list);
          filtered.retainWhere((s) {
            return stations.contains(s.StationId);
          });*/
          markers = filtered.map((Station) {
            if (notfirst && endlines.contains(Station.StationId)) {
              col = Colors.purple;
              blue = false;
            }
            notfirst = true;
            return blue?Marker(
              width: 40.0,
              height: 40.0,
              point: new LatLng(Station.Latitude, Station.Longitude),
              builder: (ctx) =>
                  Container(
                      key: Key('green'),
                      child: IconButton(
                          icon: Icon(MdiIcons.mapMarker,
                            color: Colors.blue,//col,
                            size: 40.0,),
                          //color: Colors.white,
                          onPressed: () {
                            Scaffold.of(currentContext).showSnackBar(
                                new SnackBar( //_scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(Station.StationName),
                                ));
                          }
                      )),
            ):Marker(
              width: 40.0,
              height: 40.0,
              point: new LatLng(Station.Latitude, Station.Longitude),
              builder: (ctx) =>
                  Container(
                      key: Key('green'),
                      child: IconButton(
                          icon: Icon(MdiIcons.mapMarker,
                            color: Colors.purple,//col,
                            size: 40.0,),
                          //color: Colors.white,
                          onPressed: () {
                            Scaffold.of(currentContext).showSnackBar(
                                new SnackBar( //_scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(Station.StationName),
                                ));
                          }
                      )),
            );
          }).toList();
          return new MarkerLayerOptions(markers: markers);
        }
      }
    }
    return new MarkerLayerOptions(markers: []);
  }

  LayerOptions SwitchLayers() {
    markers = null;
    if (circleMarkers != null)
      circleMarkers.clear(); //<-This might be dangerous...
    if (selectedLayer == 0) {
      print("LAYER SELECTED >> BUSES");
      markers = UpdateMarkers();
      if (_timer == null) {
        _timer = Timer.periodic(Duration(seconds: 30), (_) async {
          BusListPost temp = await GetBusInformation();
          bus_list = temp.BusList;
          circleMarkers.clear();
          setState(() {
            markers = UpdateMarkers();

            /// kETSZER HIVODIK MEG MAJD VEDD KI EZT MERT UGY IS MEG CSINALJA
          });
        });
      }
    } else if (selectedLayer == 1) {
      print("LAYER SELECTED >> LINES");
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
      }
      polylines = new List<Polyline>();
      markers = null;
      if(selectedBusId != "Off") {
        polylines.add(LinesDrawerFirstHalf());
        polylines.add(LinesDrawerLastHalf());
      }
    }
    if (markers != null) {
      return new MarkerLayerOptions(markers: markers);
    } else {
      return new PolylineLayerOptions(polylines: polylines);
    }
  }

  Polyline LinesDrawerFirstHalf() {
    Polyline temp2;
    List<LatLng> temp3 = new List<LatLng>();
    Trace line;
    if (trace_list != null) {
      line = trace_list.singleWhere((o) => o.LineID.toString() == selectedBusId, orElse: () => null);
      if(line != null && line.Points.length != 0) {
        int half=(line.Points.length/2).floor();
        temp3 = line.Points.sublist(0,half+1).map((poi) {
          return new LatLng(poi.Latitude, poi.Longitude);
        }).toList();
      }
    }
    //print(temp3);
    //temp3.removeWhere((value) => value == null);
    print(temp3);
    return Polyline(points: temp3, strokeWidth: 4.0, color: Colors.blue);
  }

  Polyline LinesDrawerLastHalf() {
    Polyline temp2;
    List<LatLng> temp3 = new List<LatLng>();
    Trace line;
    if (trace_list != null) {
      line = trace_list.singleWhere((o) => o.LineID.toString() == selectedBusId, orElse: () => null);
      if(line != null || line.Points.length != 0) {
        int half=(line.Points.length/2).floor();
        temp3 = line.Points.sublist(half).map((poi) {
          return new LatLng(poi.Latitude, poi.Longitude);
        }).toList();
      }
    }
    //print(temp3);
    //temp3.removeWhere((value) => value == null);
    print(temp3);
    return Polyline(points: temp3, strokeWidth: 4.0, color: Colors.purple);
  }

/*
      if (userLocation != null) {
        temp2.add(new Marker (
          width: 30.0,
          height: 30.0,
          point: new LatLng(
              double.parse(latitude()), double.parse(longitude())),
          builder: (ctx) =>
          new Container(
            child: FlutterLogo(),
          ),
        ));
      }
    }
    return temp2;
  }*/

  List<Marker> UpdateMarkers() {
    List<Marker> temp2;
    if (bus_list != null) {
      print("UPDATEMARKERS 111111");
      temp2 = bus_list.map((Bus) {
        return Marker(
          width: 30.0,
          height: 30.0,
          point: new LatLng(Bus.Actual_Latitude, Bus.Actual_Longitude),
          builder: (ctx) => Container(
            key: Key('purple'),
            child:  new CircleAvatar(
                foregroundColor: Colors.white,
                backgroundColor: (Bus.Points_nearby>=0)?Colors.green:Colors.amber,
                child:
                new Text(Bus.BusId)),//Icon(
              //MdiIcons.bus,
              //color: Colors.black,
            //),
          ),
        );
      }).toList();

      if (GeoPosition.userLocation != null) {
        /// SET TIMER IF THERE IS A USER LOCATION
        print("UPDATEMARKERS 22222222");
        if(MyBusId == null) {
          temp2.add(new Marker(
            width: 30.0,
            height: 30.0,
            point: new LatLng(GeoPosition.userLocation.latitude,
                GeoPosition.userLocation.longitude),
            /*double.parse(latitude()), double.parse(longitude())),*/
            builder: (ctx) =>
            new Container(
              child: Icon(
                  MdiIcons.mapMarker,
                  color: Colors.blueGrey
              ),
            ),
          ));
        }else{
          temp2.add(new Marker(
            width: 30.0,
            height: 30.0,
            point: new LatLng(GeoPosition.userLocation.latitude,
                GeoPosition.userLocation.longitude),
            /*double.parse(latitude()), double.parse(longitude())),*/
            builder: (ctx) =>
            new Container(
              child: new CircleAvatar(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  child:
                  new Text(MyBusId)),
            ),
          ));
        }
        circleMarkers = <CircleMarker>[
          CircleMarker(
              point: new LatLng(GeoPosition.userLocation.latitude,
                  GeoPosition.userLocation.longitude),
              color: Colors.blue.withOpacity(0.4),
              useRadiusInMeter: true,
              radius: (range * 1000) // 2000 meters | 2 km
              ),
        ];
      }
    }
    return temp2;
  }

  List<Marker> StationMarkers() {
    List<Marker> temp2;
    if (station_list != null) {
      temp2 = station_list.map((Station) {
        return Marker(
          width: 40.0,
          height: 40.0,
          point: new LatLng(Station.Latitude, Station.Longitude),
          builder: (ctx) => Container(
            key: Key('green'),
            child: IconButton(
                icon: Icon( MdiIcons.mapMarker,
                  color: Colors.black,
                  size: 40.0,),
                //color: Colors.white,
                onPressed: () { Scaffold.of(currentContext).showSnackBar(new SnackBar(//_scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(Station.StationName),
                ));}
            )
            /*GestureDetector(
                behavior: HitTestBehavior.translucent,
                child:FlutterLogo(colors: Colors.purple),/*Icon(
              MdiIcons.mapMarker,
              color: Colors.black,
              size: 40.0,
              ),*/
              onTap: () {
                print("Tapped!");
                Scaffold.of(currentContext).showSnackBar(new SnackBar(//_scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(Station.StationName),
              ));
            },
          ),*/),
        );
      }).toList();

      if (GeoPosition.userLocation != null) {
        temp2.add(new Marker(
          width: 30.0,
          height: 30.0,
          point: new LatLng(GeoPosition.userLocation.latitude,
              GeoPosition.userLocation.longitude),
          builder: (ctx) => new Container(
            child: Icon(
              MdiIcons.mapMarker,
              color: Colors.blueGrey,
            ),
          ),
        ));
        circleMarkers = <CircleMarker>[
          CircleMarker(
              point: new LatLng(GeoPosition.userLocation.latitude,
                  GeoPosition.userLocation.longitude),
              color: Colors.blue.withOpacity(0.4),
              useRadiusInMeter: true,
              radius: (range * 1000) // 2000 meters | 2 km
              ),
        ];
      }
    }
    return temp2;
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      print('$status');
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    currentContext = context;
    double buttonSize = ((MediaQuery.of(context).size.width-20)/4);
    var list = businfo_list.map((var value) {
      return new DropdownMenuItem<String>(
        value: value.BusId,
        child: new ListTile(
          leading: new CircleAvatar(
          foregroundColor: Colors.white,
          backgroundColor: (value.BusId == MyBusId)?Colors.red:Colors.blue,
            child: new Text(value.BusId)),
            title: Text(value.BusName),
        ),/*Text(value.BusName,
          style: TextStyle(
            fontStyle: FontStyle.italic
          ),
        ),*/
      );
    }).toList();
    list.add(new DropdownMenuItem<String>(
      value: 'Off',
      child: new Text(AppLocalizations.of(context).translate('off'),
        style: TextStyle(
          fontStyle: FontStyle.italic
        ),
      ),//Text('Off'),
    ));

    return (GeoPosition.userLocation == null)
        ? Scaffold(
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[CircularProgressIndicator()])))
        : Scaffold(
            body: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        new SizedBox(
                          width: buttonSize,//80.0,
                          child: RaisedButton(
                            child: (MyBusId==null)?Text(AppLocalizations.of(context).translate('map_btn_start_journey')):Text(MyBusId),//Text('Center'),
                            highlightColor: MyBusId==null?Color(0xFF42A5F5):Colors.redAccent,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: MyBusId==null?Colors.blue:Colors.red)),
                            textColor: MyBusId==null?Colors.blue:Colors.red,
                            color: Colors.white70,
                            onPressed: () {
                              if(MyBusId==null)
                                tabController.animateTo(0);
                            },
                          ),
                        ),
                        new SizedBox(
                          width: buttonSize,//80.0,
                          child: RaisedButton(
                            autofocus: true,//TALAN HIBA
                            child: Text(AppLocalizations.of(context).translate('map_btn_bus').toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),),//Text('Buses'),
                            highlightColor: Color(0xFF42A5F5),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: toggleBus ? Colors.white : Colors.blue)),
                            textColor: toggleBus ? Colors.white : Colors.blue,
                            color: toggleBus ? Colors.blue : Colors.white70,
                            onPressed: () {
                              print("Buses Pressed");
                              setState(() {
                                selectedLayer = 0;
                                toggleBus = true;
                                toggleStation = false;
                                toggleLine = false;
                              });
                            },
                          ),
                        ),
                        new SizedBox(
                          width: buttonSize,//80.0,
                          child: RaisedButton(
                            child: Text(AppLocalizations.of(context).translate('map_btn_lines').toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),//Text('Lines'),
                            highlightColor: Color(0xFF42A5F5),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: toggleLine ? Colors.white : Colors.blue)),
                            textColor: toggleLine ? Colors.white : Colors.blue,
                            color: toggleLine ? Colors.blue : Colors.white70,
                            onPressed: () {
                              print(
                                  "Lines Pressed"); //_animatedMapMove(LatLng(51.5, -0.09), 5.0);
                              setState(() {
                                selectedLayer = 1;
                                toggleBus = false;
                                toggleStation = false;
                                toggleLine = true;
                              });
                            },
                          ),
                        ),
                        new SizedBox(
                          width: buttonSize,//80.0,
                          child: RaisedButton(
                            child: Text(AppLocalizations.of(context).translate('map_btn_center')),//Text('Center'),
                            highlightColor: Color(0xFF42A5F5),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.blue)),
                            textColor: Colors.blue,
                            color: Colors.white70,
                            onPressed: () {
                              var bounds = LatLngBounds();
                              bounds.extend(
                                new LatLng(GeoPosition.userLocation.latitude,
                                    GeoPosition.userLocation.longitude),
                              );
                              mapController.fitBounds(
                                bounds,
                                options: FitBoundsOptions(
                                  padding:
                                      EdgeInsets.only(left: 15.0, right: 15.0),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    child:new DropdownButton<String>(
                      isExpanded: true,
                    value: selectedBusId == "Off" ? 'Off' : selectedBusId,
                    items: list.reversed.toList(),
                    onChanged: (newVal) {
                      setState(() {
                        if (newVal == 'Off') {
                          selectedBusId = "Off";
                        } else {
                          selectedBusId = newVal;
                          //Refresh lines
                        }
                      });
                    },
                  ),
                    visible: toggleLine,
                  ),
                  Flexible(
                    child: FlutterMap(
                      mapController: mapController,
                      options: new MapOptions(
                        center: new LatLng(GeoPosition.userLocation.latitude,
                            GeoPosition.userLocation.longitude),
                        zoom: 16.0,
                      ),
                      layers: [
                        new TileLayerOptions(
                          urlTemplate: "https://api.tiles.mapbox.com/v4/"
                              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                          additionalOptions: {
                            'accessToken':
                                'pk.eyJ1IjoiY29zbWFjcmlzdGlhbiIsImEiOiJjanc2dDI0d3gxZmFhNDRvNmoyMWhsZTFxIn0.rJO6tjQsfjOWi_vQmnz5jw',
                            'id': 'mapbox.streets',
                          },
                        ),
                        SwitchLayers(),
                        FilterStations(),
                        //CircleLayerOptions(circles: circleMarkers),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
