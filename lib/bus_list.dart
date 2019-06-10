import 'package:flutter/material.dart';
import 'list.dart';
import 'maps.dart';

class Buslist extends StatefulWidget{// minimal refactoring
  @override
  _BusListActionListener createState() => new _BusListActionListener();
}

class _BusListActionListener extends State<Buslist>{
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<int> bus_name = list();
  Map<int, String> _list_map = list_map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key : _scaffoldKey,
      body: new Container(
        child: new ListView.builder(
            itemBuilder: (_,int index)=>EachList(this._list_map[bus_name[index]]),
            itemCount: this.bus_name.length,
       ),
      ),
    );
  }
}

class EachList extends StatelessWidget{
  GlobalKey<ScaffoldState> _Card = GlobalKey<ScaffoldState>();
  final String name;
  final String addr="3d";/// adawdgdg
  EachList(this.name);

  @override
  int find_name(){
    var find;
    Map<int,String> map = list_map();
    for (int key in map.keys){
      if (map[key] == name){
        find = key;
      }
    }
    return find;
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      key: _Card,
      child: new Container(
        padding: EdgeInsets.all(8.0),
        child: new Row(
          children: <Widget>[
            new CircleAvatar(child: new Text(find_name().toString()),),
            new Padding(padding: EdgeInsets.only(right: 10.0)),
            new Text(name, style: TextStyle(fontSize: 20.0),),
          ],
        ),
      ),
    );
  }
}

