class TraceListPost {
  final List<Trace> TraceList;

  TraceListPost({
    this.TraceList,
  });


  factory TraceListPost.fromJson(List<dynamic> parsedJson) {

    List<Trace> lns = new List<Trace>();
    for(int i=0;i<parsedJson.length;i++){
      lns.add(Trace.fromJson(parsedJson.elementAt(i)));
    }

    //buses = parsedJson.map((i) => Bus.fromJson(i)).toList();

    return new TraceListPost(
      TraceList: lns,
    );
  }

}

class Trace{
  String LineID;
  List<point> Points;

  Trace({this.LineID,this.Points});

  factory Trace.fromJson(Map<String, dynamic> json){
    List<point> ets = new List<point>();
    for(int i=0;i<json['Points'].length;i++){
      ets.add(point.fromJson(json['Points'].elementAt(i)));
    }
    return new Trace(
        LineID: json['LineID'],
        Points: ets
    );
  }

  @override
  String toString() {
    return LineID.toString()+"  "+Points.toString();
  }
}

class point{
  double Longitude;
  double Latitude;

  point({this.Longitude,this.Latitude});

  factory point.fromJson(Map<String, dynamic> json){
    return new point(
        Longitude: json['Longitude'],
        Latitude: json['Latitude']
    );
  }



  @override
  String toString() {
    return Longitude.toString()+"  "+Latitude.toString();
  }
}

