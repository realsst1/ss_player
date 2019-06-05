import 'dart:math';

import 'bottom_controls.dart';
import 'package:flutter/material.dart';
import 'package:ss_player/songs.dart';
import 'package:ss_player/theme.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SS Player",
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        title: new Text(""),
        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios
          ),
          color: const Color(0xFFDDDDDD),
          onPressed: ()=>{},
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
                Icons.menu
            ),
            color: const Color(0xFFDDDDDD),
            onPressed: ()=>{},
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          //seekbar
          new Expanded(
            child: new Center(
              child: new Container(
                width: 125.0,
                height: 125.0,
                child: new ClipOval(
                  clipper: new CircleClipper(),
                  child: Image.network(
                    demoPlaylist.songs[0].albumArtUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            ),
          ),


          //visualizer
          new Container(
            width: double.infinity,
            height: 125.0,
          ),

          //song details
          new BottomControls()
        ],
      ),
    );
  }
}



