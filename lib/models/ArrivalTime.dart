class ArrivalTime {
  String busID;
  String TheTimeString;
  String requiredTime;

  ArrivalTime({this.busID, this.TheTimeString, this.requiredTime});

  factory ArrivalTime.fromJson(Map<String, dynamic> json) {
    return new ArrivalTime(
        busID: json['busID'].toString(),
        TheTimeString: json['TheTimeString'].toString(),
        requiredTime: json['requiredTime'].toString());
  }

  @override
  String toString() {
    return busID + " will arrive in : " + TheTimeString + "\n";
  }
}

class ArrivalTimeListPost {
  final List<ArrivalTime> ArrivalTimeList;

  ArrivalTimeListPost({
    this.ArrivalTimeList,
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

  factory ArrivalTimeListPost.fromJson(List<dynamic> parsedJson) {
    List<ArrivalTime> ArrivalTimes = new List<ArrivalTime>();
    for (int i = 0; i < parsedJson.length; i++) {
      ArrivalTimes.add(ArrivalTime.fromJson(parsedJson.elementAt(i)));
    }

    //buses = parsedJson.map((i) => Bus.fromJson(i)).toList();

    return new ArrivalTimeListPost(
      ArrivalTimeList: ArrivalTimes,
    );
  }
}
