
List<int> list(){
  final List<int> _listBus = [
    26,27,44,4,20
  ];
  return _listBus;
}

int list_size(){
  var list_bus = list();
  return list_bus.length;
}

Map<int, String> list_map(){
  Map<int, String> _list_bus_map;
  _list_bus_map = {
    27 : "Sapientia - Spitalul Judetean",
    44 : "Sapientia - Combinat",
    4 : "Combinat - Aleea Carpati",
    26 : "Sapientia - Aleea Carpati",
    20 : "Centrofarm - Spaital Judetean"
  };
  return _list_bus_map;
}
