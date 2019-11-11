import 'package:bus_project/screens/SettingsPage/geolocation.dart';
import 'package:bus_project/services/AppLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:bus_project/screens/MapPage/maps.dart';
import 'package:bus_project/screens/BusListPage/bus_list.dart';


class start extends StatefulWidget {
  @override
  _newBar createState() => new _newBar();
}

class _newBar extends State<start> with SingleTickerProviderStateMixin {
  TabController tabController;

  //Future<Post> post;
  @override
  void initState() {
    super.initState();
    //DrivingDetector = ActivityRecognition();
    //GeoPosition = GPS();
    tabController = TabController(length: 3, vsync: this);
    //post = fetchPost('https://putsreq.com/Ys5rRZMUkZbBlazbTtLF');
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: SafeArea(
            child: getTabBar(),
          ),
        ),
        body: getTabBarPages());
    /*return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('main_title')),//Text('Where is my bus?'),
        bottom: TabBar(controller: tabController, tabs: [
          Text(AppLocalizations.of(context).translate('menu_buses')),//Text('Station'),
          Text(AppLocalizations.of(context).translate('menu_maps')),//Text('Maps'),
          Text(AppLocalizations.of(context).translate('menu_settings')),//Text('Settings'),
        ]),
      ),
      body: TabBarView(
          controller: tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Buslist1(),
            Maps(),
            GeoListenPage(),
          ]),
    );*/
  }

  Widget getTabBar() {
    return TabBar(controller: tabController, tabs: [
      Tab(text: AppLocalizations.of(context).translate('menu_buses')),//Text('Station'),
      Tab(text: AppLocalizations.of(context).translate('menu_maps')),//Text('Maps'),
      Tab(text: AppLocalizations.of(context).translate('menu_settings')),//Text('Settings'),
    ]);
  }

  Widget getTabBarPages() {
    return TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Buslist1(),
          Maps(),
          GeoListenPage(),
        ]);
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
