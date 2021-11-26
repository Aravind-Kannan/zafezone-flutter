import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zafezone/theme/colors.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';

class IndexPage extends StatefulWidget {
  // const IndexPage({Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List locList = [];
  bool isLoading = false;
  late Timer timer;
  int phoneNumber = 6384354006;

  @override
  void initState() {
    super.initState();
    this.fetchLoc();
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => this.fetchLoc());
  }

  fetchLoc() async {
    setState(() {
      isLoading = true;
    });
    String url = "http://zafezone-flask.herokuapp.com/loc/${phoneNumber}";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      setState(() {
        locList = items;
        isLoading = false;
      });
    } else {
      setState(() {
        locList = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zafe zone"),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if(locList.contains(null) || locList.length < 0 || isLoading){
      return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primary),));
    }
    return ListView.builder(
      itemCount: locList.length,
        itemBuilder: (context, index) {
      return getCard(locList[index]);
    });
  }

  Widget getCard(item) {
    bool emergency = item['emergency'];
    double longitude = double.parse(item['longitude']);
    double latitude = double.parse(item['latitude']);
    String sentAt = item['sent_at'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: emergency ? danger : safe,
                    borderRadius: BorderRadius.circular(60/2)
                ),
              ),
              SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("(${latitude.toString()}, ${longitude.toString()})", style: TextStyle(fontSize: 17)),
                  SizedBox(height: 10.0),
                  Text(sentAt, style: TextStyle(color: Colors.grey),)
                ],
              )
            ],
          ),
          onTap: () {
            MapsLauncher.launchCoordinates(latitude, longitude);
          },
          // onTap: () async {
          //   final String urlMaps = "https://www.google.com/maps/?q=" + longitude + "," + latitude;
          //   // final String googleMapsUrl = "comgooglemaps://?center=$latitude,$longitude";
          //   final String mapSchema = "https://www.google.com/maps/search/?api=1&query=${longitude},${latitude}";
          //   await canLaunch(urlMaps) ? await launch(urlMaps) : throw 'Could not launch $urlMaps';;
          // },
        ),
      ),
    );
  }
}
