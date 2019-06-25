import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';


Future<DateTime> Syncronization() async {
  final response =
  await http.get('http://192.168.1.101:8080/WCFService/Service1/web/Syncronization');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    var actualtime = DateTime.parse((json.decode(response.body) as String)+"Z");
    print(actualtime.toString());
    return actualtime;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<BusListPost> GetBusInformation() async {
  final response =
  await http.get("http://192.168.1.101:8080/WCFService/Service1/web/GetBusInformation");//'https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var temp = BusListPost.fromJson(json.decode(response.body));
    temp.BusList.forEach((f)=> print(f.toString()));
    return temp;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<StationListPost> GetStationsList() async {
  final response =
  await http.get("http://192.168.1.101:8080/WCFService/Service1/web/GetStationsList");

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var temp = StationListPost.fromJson(json.decode(response.body));
    temp.StationList.forEach((f)=> print(f.toString()));
    return temp;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

void PostBusInformation(Map body) async {
  return http.post("http://192.168.1.101:8080/WCFService/Service1/web/PostBusInformation"/*"https://ptsv2.com/t/15kcv-1561457757/post"*/,headers: {"Content-Type": "application/json"}, body: json.encode(body)).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while posting data");
    }
    //print("Success!!!!");
    return;
  });
}

Future<Post> createPost(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return Post.fromJson(json.decode(response.body));
  });
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

void GetList() async {
  Socket socket = await Socket.connect('192.168.1.101', 8080);
  print('Connected to: ''${socket.remoteAddress.address}:${socket.remotePort}');

  // listen to the received data event stream
  socket.listen((List<int> event) {
    print(utf8.decode(event));
  });

  // send hello
  //socket.add(utf8.encode('hello'));

  // wait 5 seconds
  await Future.delayed(Duration(seconds: 5));

  // .. and close the socket
  socket.close();
}
////////////////////////////////////////MODELS (PUT THESE ELSEWHERE)////////
class Bus {
  String BusId;
  String BusName;
  double Actual_Latitude;
  double Actual_Longitude;
  String Measurement_Timestamp;

  Bus({this.BusId,this.BusName,this.Actual_Latitude,this.Actual_Longitude,this.Measurement_Timestamp});

  factory Bus.fromJson(Map<String, dynamic> json){
    return new Bus(
        BusId: json['BusId'].toString(),
        BusName: json['BusId'].toString(), /// <<-- CHANGE THIS WHEN THE NAME WILL BE ADDED
        Actual_Longitude: json['Actual_Longitude'].toDouble(),
        Actual_Latitude: json['Actual_Latitude'].toDouble(),
        Measurement_Timestamp : json['Measurement_Timestamp'].toString()
    );
  }

  @override
  String toString() {
    return BusName+" Latitude: "+Actual_Latitude.toString()+" Longitude: "+Actual_Longitude.toString();
  }
}

class BusListPost {
  final List<Bus> BusList;

  BusListPost({
    this.BusList,
  });

/*
  factory BusListPost.fromJson(Map<String, dynamic> json) {
    List<Bus> buses = new List<Bus>();
    //buses = json.map((i)=>Bus.fromJson(i)).toList();
    buses=json.map((i) => Bus.fromJson(i)).toList();
    return new BusListPost(
        BusList: buses
    );
  }*/

  factory BusListPost.fromJson(List<dynamic> parsedJson) {

    List<Bus> buses = new List<Bus>();
    for(int i=0;i<parsedJson.length;i++){
      buses.add(Bus.fromJson(parsedJson.elementAt(i)));
    }

    //buses = parsedJson.map((i) => Bus.fromJson(i)).toList();

    return new BusListPost(
      BusList: buses,
    );
  }

}

class Station {
  String StationId;
  String StationName;
  double Latitude;
  double Longitude;

  Station({this.StationId,this.StationName,this.Latitude,this.Longitude});

  factory Station.fromJson(Map<String, dynamic> json){
    return new Station(
        StationId: json['StationId'].toString(),
        StationName: json['StationName'].toString(),
        Longitude: json['Longitude'].toDouble(),
        Latitude: json['Latitude'].toDouble()
    );
  }

  @override
  String toString() {
    return StationName+" Latitude: "+Latitude.toString()+" Longitude: "+Longitude.toString()+"\n";
  }
}

class StationListPost {
  final List<Station> StationList;

  StationListPost({
    this.StationList,
  });

/*
  factory BusListPost.fromJson(Map<String, dynamic> json) {
    List<Bus> buses = new List<Bus>();
    //buses = json.map((i)=>Bus.fromJson(i)).toList();
    buses=json.map((i) => Bus.fromJson(i)).toList();
    return new BusListPost(
        BusList: buses
    );
  }*/

  factory StationListPost.fromJson(List<dynamic> parsedJson) {

    List<Station> stations = new List<Station>();
    for(int i=0;i<parsedJson.length;i++){
      stations.add(Station.fromJson(parsedJson.elementAt(i)));
    }

    //buses = parsedJson.map((i) => Bus.fromJson(i)).toList();

    return new StationListPost(
      StationList: stations,
    );
  }

}

