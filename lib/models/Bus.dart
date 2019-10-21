class Bus {
  String BusId;
  String BusName;
  double Actual_Latitude;
  double Actual_Longitude;
  String Measurement_Timestamp;

  Bus(
      {this.BusId,
      this.BusName,
      this.Actual_Latitude,
      this.Actual_Longitude,
      this.Measurement_Timestamp});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return new Bus(
        BusId: json['BusId'].toString(),
        BusName: json['BusName'].toString(),
        Actual_Longitude: json['Actual_Longitude'].toDouble(),
        Actual_Latitude: json['Actual_Latitude'].toDouble(),
        Measurement_Timestamp: json['Measurement_Timestamp'].toString());
  }

  @override
  String toString() {
    return BusName +
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
