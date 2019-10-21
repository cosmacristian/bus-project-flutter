import 'package:bus_project/screens/Shared/list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    currentContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Incomming Buses"),
      ),
      body: Center(
          child: ListView.builder(
              itemCount: bus_list.length,
              itemBuilder: (context, index) {
                return ListTile(
                    leading: new CircleAvatar(
                        child:
                            new Text(arrivaltime_list.elementAt(index).busID)),
                    title: Text(arrivaltime_list.elementAt(index).toString()));
              })),
    );
  }
}
