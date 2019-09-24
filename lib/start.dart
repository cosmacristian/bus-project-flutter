import 'package:bus_project/geolocation.dart';
import 'package:flutter/material.dart';
import 'maps.dart';
import 'bus_list.dart';


class start extends StatefulWidget{
  @override
  _newBar createState() => new _newBar();
}

class _newBar extends State<start> with SingleTickerProviderStateMixin{
  TabController tabController;
  //Future<Post> post;
  @override
  void initState(){
    super.initState();
    tabController= TabController(length: 3, vsync: this);
    //post = fetchPost('https://putsreq.com/Ys5rRZMUkZbBlazbTtLF');
  }

  @override
  void dispose(){
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Where is my bus?'), bottom: TabBar(controller: tabController, tabs: [
        Text('Station'),
        Text('Maps'),
        Text('Settings'),
      ]),
      ),
      body: TabBarView(controller: tabController,physics: NeverScrollableScrollPhysics(), children: [
        Buslist1(),
        Maps(),
        GeoListenPage(),
      ]),
    );
  }

  /*Future<String> apiRequest(String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }*/

}
