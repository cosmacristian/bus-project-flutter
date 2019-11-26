import 'dart:async';
import 'dart:convert';
import 'package:bus_project/models/BusInfo.dart';
import 'package:bus_project/models/Trace.dart';
import 'package:http/http.dart' as http;
import 'package:bus_project/models/ArrivalTime.dart';
import 'package:bus_project/models/Bus.dart';
import 'package:bus_project/models/Line.dart';
import 'package:bus_project/models/Station.dart';
import 'package:bus_project/models/Timetable.dart';

Future<DateTime> Syncronization() async {
  final response = await http
      .get('http://193.226.0.198:5210/WCFService/Service1/web/Syncronization');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    DateTime actualtime = DateTime.parse(json.decode(response.body) as String);
    print(actualtime.toString());
    return actualtime;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<BusListPost> GetBusInformation() async {
  final response = await http.get(
      "http://193.226.0.198:5210/WCFService/Service1/web/GetBusInformation"); //'https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var temp = BusListPost.fromJson(json.decode(response.body));
    temp.BusList.forEach((f) => print(f.toString()));
    return temp;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<LineListPost> GetLinesList() async {
  final response = await http
      .get("http://193.226.0.198:5210/WCFService/Service1/web/GetLinesList");

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var temp = LineListPost.fromJson(json.decode(response.body));
    temp.LineList.forEach((f) => print(f.toString()));
    return temp;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<TraceListPost> GetTracesList() async {
  final response = await http
      .get("http://193.226.0.198:5210/WCFService/Service1/web/GetTracesList");

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var temp = TraceListPost.fromJson(json.decode(response.body));
    temp.TraceList.forEach((f) => print(f.toString()));
    return temp;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<BusInfoListPost> GetBusesList() async {
  final response = await http
      .get("http://193.226.0.198:5210/WCFService/Service1/web/GetBusesList");

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var temp = BusInfoListPost.fromJson(json.decode(response.body));
    temp.BusInfoList.forEach((f) => print(f.toString()));
    return temp;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<StationListPost> GetStationsList() async {
  final response = await http
      .get("http://193.226.0.198:5210/WCFService/Service1/web/GetStationsList");

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var temp = StationListPost.fromJson(json.decode(response.body));
    temp.StationList.forEach((f) => print(f.toString()));
    return temp;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<TimetableListPost> GetTimetable() async {
  final response = await http
      .get("http://193.226.0.198:5210/WCFService/Service1/web/GetTimetable");

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var temp = TimetableListPost.fromJson(json.decode(response.body));
    //temp.TimetableList.forEach((f)=> print(f.toString()));
    return temp;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

void PostBusInformation(Map body) async {
  return http
      .post(
          "http://193.226.0.198:5210/WCFService/Service1/web/PostBusInformation" /*"https://ptsv2.com/t/15kcv-1561457757/post"*/,
          headers: {"Content-Type": "application/json"},
          body: json.encode(body))
      .then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while posting data");
    }
    //print("Success!!!!");
    return;
  });
}

void PostBusInformationTest(Map body) async {
  return http
      .post(
          "http://193.226.0.198:5210/WCFService/Service1/web/PostBusMeasurement",
          headers: {"Content-Type": "application/json"},
          body: json.encode(body))
      .then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while posting data");
    }
    //print("Success!!!!");
    return;
  });
}

Future<ArrivalTimeListPost> GetTimeList(int StationID) async {
  final response = await http.get(
      "http://193.226.0.198:5210/WCFService/Service1/web/GetTimeList?StationID=" +
          StationID.toString());

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var temp = ArrivalTimeListPost.fromJson(json.decode(response.body));
    temp.ArrivalTimeList.forEach((f) => print(f.toString()));
    return temp;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}
