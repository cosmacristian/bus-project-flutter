class Bus {
  String BusId;
  double Actual_Latitude;
  double Actual_Longitude;
  String Measurement_Timestamp;
  int Points_nearby;

  Bus(
      {this.BusId,
      this.Actual_Latitude,
      this.Actual_Longitude,
      this.Measurement_Timestamp,
      this.Points_nearby});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return new Bus(
        BusId: json['BusId'].toString(),
        Actual_Longitude: json['Actual_Longitude'].toDouble(),
        Actual_Latitude: json['Actual_Latitude'].toDouble(),
        Measurement_Timestamp: json['Measurement_Timestamp'].toString(),
        Points_nearby: json['Points_nearby']
    );
  }

  @override
  String toString() {
    return BusId +
        " Latitude: " +
        Actual_Latitude.toString() +
        " Longitude: " +
        Actual_Longitude.toString();
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
    for (int i = 0; i < parsedJson.length; i++) {
      buses.add(Bus.fromJson(parsedJson.elementAt(i)));
    }

    //buses = parsedJson.map((i) => Bus.fromJson(i)).toList();

    return new BusListPost(
      BusList: buses,
    );
  }
}
