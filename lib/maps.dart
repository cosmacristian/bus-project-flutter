import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'communication.dart';
import 'geolocation.dart';
import 'list.dart';

class Maps extends StatefulWidget{
  @override
  Maps_flutter createState() => new Maps_flutter();
}

class Maps_flutter extends State<Maps>{
  List<Marker> markers;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    if(station_list == null) {
      GetStationsList().then((val) =>
            station_list = val.StationList
      );
    }
    markers = UpdateMarkers();
    print("MARKERS SET CREATING TIMER");
    _timer = Timer.periodic(Duration(seconds: 30), (_) async {
      BusListPost temp = await GetBusInformation();
      bus_list = temp.BusList;
      setState(() {
        markers = UpdateMarkers();
      });
    });
  }/// SET TIMER IF THERE IS A USER LOCATION


  List<Marker> UpdateMarkers() {
    List<Marker> temp2;
    if (bus_list != null) {
      print("UPDATEMARKERS 111111");
      temp2 = bus_list.map((Bus) {
        return Marker(
          width: 30.0,
          height: 30.0,
          point: new LatLng(Bus.Actual_Latitude, Bus.Actual_Longitude),
          builder: (ctx) =>
              Container(
                key: Key('purple'),
                child: FlutterLogo(),
              ),
        );
      }).toList();

      if (userLocation != null) {
        /// SET TIMER IF THERE IS A USER LOCATION
        print("UPDATEMARKERS 22222222");
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
  }

  @override
  void dispose() {
    super.dispose();
    if(_timer != null){
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context){
    return (userLocation == null || markers ==null)
        ? Scaffold(
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[CircularProgressIndicator()]
                )
            )
        )
        :new FlutterMap(
      options: new MapOptions(
          center: LatLng(double.parse(latitude()), double.parse(longitude())),
          zoom: 16.0,
        ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
          "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': 'pk.eyJ1IjoiY29zbWFjcmlzdGlhbiIsImEiOiJjanc2dDI0d3gxZmFhNDRvNmoyMWhsZTFxIn0.rJO6tjQsfjOWi_vQmnz5jw',
            'id': 'mapbox.streets',
          },
        ),
        new MarkerLayerOptions(
          markers: markers,
        ),
      ],
    );
  }
}

