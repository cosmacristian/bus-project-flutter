class LineListPost {
  final List<Line> LineList;

  LineListPost({
    this.LineList,
  });


  factory LineListPost.fromJson(List<dynamic> parsedJson) {

    List<Line> lns = new List<Line>();
    for(int i=0;i<parsedJson.length;i++){
      lns.add(Line.fromJson(parsedJson.elementAt(i)));
    }

    //buses = parsedJson.map((i) => Bus.fromJson(i)).toList();

    return new LineListPost(
      LineList: lns,
    );
  }

}

class Line{
  String LineID;
  List<entry> Stations;

  Line({this.LineID,this.Stations});

  factory Line.fromJson(Map<String, dynamic> json){
    List<entry> ets = new List<entry>();
    for(int i=0;i<json['Stations'].length;i++){
      ets.add(entry.fromJson(json['Stations'].elementAt(i)));
    }
    return new Line(
        LineID: json['LineID'],
        Stations: ets
    );
  }

  @override
  String toString() {
    return LineID.toString()+"  "+Stations.toString();
  }
}

class entry{
  int StationID;
  int StationNr;

  entry({this.StationID,this.StationNr});

  factory entry.fromJson(Map<String, dynamic> json){
    return new entry(
        StationID: json['StationID'],
        StationNr: json['StationNr']
    );
  }



  @override
  String toString() {
    return StationID.toString()+"  "+StationNr.toString();
  }
}

