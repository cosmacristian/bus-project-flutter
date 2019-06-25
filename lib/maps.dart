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

class Maps_flutter extends State<Maps> with TickerProviderStateMixin{
  List<Marker> markers;
  Timer _timer;
  MapController mapController;
  int selectedLayer=0;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    if(station_list == null) {
      GetStationsList().then((val) =>
            station_list = val.StationList
      );
    }
  }

  LayerOptions SwitchLayers(){
    if(selectedLayer == 0){
      print("LAYER SELECTED >> BUSES");
      markers = UpdateMarkers();
      if(_timer == null) {
        _timer = Timer.periodic(Duration(seconds: 30), (_) async {
          BusListPost temp = await GetBusInformation();
          bus_list = temp.BusList;
          setState(() {
            markers = UpdateMarkers();/// kETSZER HIVODIK MEG MAJD VEDD KI EZT MERT UGY IS MEG CSINALJA
          });
        });
      }
    }else if(selectedLayer == 1){
      print("LAYER SELECTED >> STATIONS");
      if(_timer != null){
        _timer.cancel();
        _timer = null;
      }
      markers = StationMarkers();
    }
    if(markers != null) {
      return new MarkerLayerOptions(markers: markers);
    }else{
      return new MarkerLayerOptions(markers: new List<Marker>());
    }
  }


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

  List<Marker> StationMarkers() {
    List<Marker> temp2;
    if (station_list != null) {
      temp2 = station_list.map((Station) {
        return Marker(
          width: 30.0,
          height: 30.0,
          point: new LatLng(Station.Latitude, Station.Longitude),
          builder: (ctx) =>
              Container(
                key: Key('green'),
                child: FlutterLogo(),
              ),
        );
      }).toList();

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
  }

  @override
  void dispose() {
    super.dispose();
    if(_timer != null){
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
  Widget build(BuildContext context){
    return (userLocation == null)
        ? Scaffold(
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[CircularProgressIndicator()]
                )
            )
        )
        : Scaffold(
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
              children: [
          Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Row(
            children: <Widget>[
              MaterialButton(
                child: Text('Buses'),
                onPressed: () {
                  print("Buses Pressed");
                  setState(() {
                    selectedLayer = 0;
                  });
                },
              ),
              MaterialButton(
                child: Text('Stations'),
                onPressed: () {
                  print("Stations Pressed");//_animatedMapMove(LatLng(51.5, -0.09), 5.0);
                  setState(() {
                    selectedLayer = 1;
                  });
                },
              ),
              MaterialButton(
                child: Text('Lines'),
                onPressed: () {
                  print("Lines Pressed");//_animatedMapMove(LatLng(51.5, -0.09), 5.0);
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Row(
            children: <Widget>[
              MaterialButton(
                child: Text('Fit Bounds'),
                onPressed: () {
                  var bounds = LatLngBounds();
                  bounds.extend(LatLng(double.parse(latitude()), double.parse(longitude())));
                  mapController.fitBounds(
                    bounds,
                    options: FitBoundsOptions(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Flexible(
        child: FlutterMap(
          mapController: mapController,
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
            SwitchLayers(),
          ],
        ),
        ),
              ],
          ),
        ),
    );
  }
}