class Timetable {
  String busNr;
  String startTime;
  String stationID;

  Timetable({this.busNr, this.startTime, this.stationID});

  factory Timetable.fromJson(Map<String, dynamic> json) {
    return new Timetable(
        busNr: json['busNr'].toString(),
        startTime: json['startTime'].toString(),
        stationID: json['stationID'].toString());
  }

  @override
  String toString() {
    return busNr + " will start : " + startTime + " from " + stationID + "\n";
  }
}

class TimetableListPost {
  final List<Timetable> TimetableList;

  TimetableListPost({
    this.TimetableList,
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

  factory TimetableListPost.fromJson(List<dynamic> parsedJson) {
    List<Timetable> Timetables = new List<Timetable>();
    for (int i = 0; i < parsedJson.length; i++) {
      Timetables.add(Timetable.fromJson(parsedJson.elementAt(i)));
    }

    //buses = parsedJson.map((i) => Bus.fromJson(i)).toList();

    return new TimetableListPost(
      TimetableList: Timetables,
    );
  }
}
