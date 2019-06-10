import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'geolocation.dart';

class Maps extends StatefulWidget{
  @override
  Maps_flutter createState() => new Maps_flutter();
}

class Maps_flutter extends State<Maps>{
  @override
  Widget build(BuildContext){
    return new FlutterMap(
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
          markers: [
            new Marker (
              width: 30.0,
              height: 30.0,
              point: new LatLng(double.parse(latitude()), double.parse(longitude())),
              builder: (ctx) => new Container(
                child: FlutterLogo(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

