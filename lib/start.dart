import 'package:flutter/material.dart';
import 'maps.dart';
import 'bus_list.dart';
import 'geolocation.dart';

class start extends StatefulWidget{
  @override
  _newBar createState() => new _newBar();
}

class _newBar extends State<start> with SingleTickerProviderStateMixin{
  TabController tabController;

  @override
  void initState(){
    super.initState();
    tabController= TabController(length: 3, vsync: this);
  }

  @override
  void dispose(){
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('BusApp'), bottom: TabBar(controller: tabController, tabs: [
        Text('Station'),
        Text('Maps'),
        Text('Get Location'),
      ]),
      ),
      body: TabBarView(controller: tabController, children: [
        Buslist(),
        Maps(),
        GeoListenPage(),
        //Container(color: Colors.teal),
        //Container(color: Colors.cyanAccent,),
      ]),
    );
  }
}