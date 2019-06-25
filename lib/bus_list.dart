import 'package:flutter/material.dart';
import 'list.dart';
import 'maps.dart';
import 'communication.dart';

class Buslist1 extends StatefulWidget{
  @override
  _BusListActionListener createState() => new _BusListActionListener();
}

class _BusListActionListener extends  State<Buslist1>{
  //List<int> bus_name = list();
  //Map<int, String> _list_map = list_map();



  /*@override
  int find_name(String name){
    var find;
    Map<int,String> map = list_map();
    for (int key in map.keys){
      if (map[key] == name){
        find = key;
      }
    }
    return find;
  }*/

  @override
  Widget build(BuildContext context) {
    if(bus_list == null) {
      GetBusInformation().then((val) =>
          setState(() {
            bus_list = val.BusList;
          })
      );
    }
    return bus_list == null
        ? Scaffold(
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, ///new
                    children: <Widget>[CircularProgressIndicator()]
                )
            )
        )
        : ListView.builder(
        itemCount: bus_list.length,
        itemBuilder: (context, index){
          return ListTile(
            leading: new CircleAvatar(child: new Text(bus_list.elementAt(index).BusId)),
            title: Text(bus_list.elementAt(index).Actual_Longitude.toString()),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: (){
              print("Rovid gomb nyomas");
            },
            onLongPress: (){
              print("Hosszu gomb nyomas");
            },
          );
        },
    );
  }
}