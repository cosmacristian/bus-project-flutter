class Station {
  String StationId;
  String StationName;
  double Latitude;
  double Longitude;

  Station({this.StationId, this.StationName, this.Latitude, this.Longitude});

  factory Station.fromJson(Map<String, dynamic> json) {
    return new Station(
        StationId: json['StationId'].toString(),
        StationName: json['StationName'].toString(),
        Longitude: json['Longitude'].toDouble(),
        Latitude: json['Latitude'].toDouble());
  }

  @override
  String toString() {
    return StationName +
        " Latitude: " +
        Latitude.toString() +
        " Longitude: " +
        Longitude.toString() +
        "\n";
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
    for (int i = 0; i < parsedJson.length; i++) {
      stations.add(Station.fromJson(parsedJson.elementAt(i)));
    }

    //buses = parsedJson.map((i) => Bus.fromJson(i)).toList();

    return new StationListPost(
      StationList: stations,
    );
  }
}
