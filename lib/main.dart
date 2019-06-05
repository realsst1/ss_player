import 'package:flutter/material.dart';
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
            child: new Container(

            ),
          ),


          //visualizer
          new Container(
            width: double.infinity,
            height: 125.0,
          ),

          //song details
          new Container(
            color: accentColor,
            child: Padding(
              padding: const EdgeInsets.only(top:40.0,bottom: 50.0),
              child: new Column(
                children: <Widget>[
                  new RichText(
                      text: new TextSpan(
                        text: '',
                        children: [
                          new TextSpan(
                            text: 'Song Title\n',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4.0,
                              height: 1.5
                            )
                          ),
                          new TextSpan(
                            text: "Artist Name",
                            style: new TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12.0,
                              letterSpacing: 3.0,
                              height: 1.5
                            )
                          )
                        ]
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:40.0),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(child:new Container()),
                        new IconButton(
                          icon: new Icon(
                              Icons.skip_previous,
                            color: Colors.white,
                            size: 35.0,
                          ),
                          onPressed: ()=>{},
                        ),

                        new Expanded(child: new Container()),

                        new RawMaterialButton(
                          shape: new CircleBorder(),
                          fillColor: Colors.white,
                          splashColor: lightAccentColor,
                          highlightColor: lightAccentColor.withOpacity(0.50),
                          elevation: 10.0,
                          highlightElevation: 5.0,
                          onPressed: ()=>{},
                          child: new Padding(
                            padding: EdgeInsets.all(8.0),
                            child: new Icon(
                              Icons.play_arrow,
                              color: darkAccentColor,
                              size: 35.0,
                            ),
                          ),
                        ),

                        new Expanded(child: new Container()),

                        new IconButton(
                          icon: new Icon(
                              Icons.skip_next,
                            color: Colors.white,
                            size: 35.0,
                          ),
                          onPressed: ()=>{},
                        ),
                        new Expanded(child: new Container())
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}




