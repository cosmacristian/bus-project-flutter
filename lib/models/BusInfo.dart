class BusInfo {
  String BusId;
  String BusName;

  BusInfo({this.BusId, this.BusName});

  factory BusInfo.fromJson(Map<String, dynamic> json) {
    return new BusInfo(
        BusId: json['BusId'].toString(),
        BusName: json['BusName'].toString());
  }

  @override
  String toString() {
    return BusName +
        " Id: " +
        BusId +
        "\n";
  }
}

class BusInfoListPost {
  final List<BusInfo> BusInfoList;

  BusInfoListPost({
    this.BusInfoList,
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

  factory BusInfoListPost.fromJson(List<dynamic> parsedJson) {
    List<BusInfo> BusInfos = new List<BusInfo>();
    for (int i = 0; i < parsedJson.length; i++) {
      BusInfos.add(BusInfo.fromJson(parsedJson.elementAt(i)));
    }

    //buses = parsedJson.map((i) => Bus.fromJson(i)).toList();

    return new BusInfoListPost(
      BusInfoList: BusInfos,
    );
  }
}
