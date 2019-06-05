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
                width: 140.0,
                height: 140.0,
                child: new RadialSeekBar(
                  progressPercent: 0.2,
                  thumbPosition: 0.2,
                  innerPadding: EdgeInsets.all(10.0),
                  progressColor: accentColor,
                  thumbColor: lightAccentColor,
                  trackColor: Colors.grey[300],
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

class RadialSeekBar extends StatefulWidget {

  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double thumbSize;
  final Color thumbColor;
  final double progressPercent;
  final double thumbPosition;
  final Widget child;
  final EdgeInsets outerPadding;
  final EdgeInsets innerPadding;

  RadialSeekBar({
    this.trackWidth=3.0,
    this.trackColor=Colors.grey,
    this.progressWidth=5.0,
    this.progressColor=Colors.black,
    this.thumbSize=10.0,
    this.thumbColor=Colors.black,
    this.progressPercent=0.0,
    this.thumbPosition=0.0,
    this.innerPadding=const EdgeInsets.all(0.0),
    this.outerPadding=const EdgeInsets.all(0.0),
    this.child
  });

  @override
  _RadialSeekBarState createState() => _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {

  EdgeInsets _insetsForPainter(){
    final outerThickness=max(widget.trackWidth,max(widget.progressWidth,widget.thumbSize))/2.0;
    return new EdgeInsets.all(outerThickness);

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.outerPadding,
      child: CustomPaint(
        foregroundPainter: new RadialSeekBarPainter(
          trackWidth: widget.trackWidth,
          trackColor: widget.trackColor,
          progressWidth: widget.progressWidth,
          progressColor: widget.progressColor,
          progressPercent: widget.progressPercent,
          thumbSize: widget.thumbSize,
          thumbColor: widget.thumbColor,
          thumbPosition: widget.thumbPosition
        ),
        child: new Padding(
          padding: _insetsForPainter()+widget.innerPadding,
            child: widget.child
        ),
      ),
    );
  }
}

class RadialSeekBarPainter extends CustomPainter{

  final double trackWidth;
  final double progressWidth;
  final double thumbSize;
  final double progressPercent;
  final double thumbPosition;
  final Paint trackPaint;
  final Paint progressPaint;
  final Paint thumbPaint;

  RadialSeekBarPainter({
    @required this.trackWidth,
    @required trackColor,
    @required this.progressWidth,
    @required progressColor,
    @required this.thumbSize,
    @required thumbColor,
    @required this.progressPercent,
    @required this.thumbPosition,
  }) : trackPaint=new Paint()
        ..color=trackColor
        ..style=PaintingStyle.stroke
        ..strokeWidth=trackWidth,
      progressPaint=new Paint()
        ..color=progressColor
        ..style=PaintingStyle.stroke
        ..strokeCap=StrokeCap.round
        ..strokeWidth=progressWidth,
      thumbPaint=new Paint()
        ..color=thumbColor
        ..style=PaintingStyle.fill
        ..strokeWidth=thumbSize;


  @override
  void paint(Canvas canvas, Size size) {

    final outerThickness=max(trackWidth,max(progressWidth,thumbSize));
    Size constrainedSize=new Size(size.width-outerThickness, size.height-outerThickness);


    final center=new Offset(size.width/2,size.height/2);
    final radius=min(constrainedSize.width,constrainedSize.height)/2;
    // TODO: implement paint
    //paint track
    canvas.drawCircle(center, radius, trackPaint);

    //paint progress
    final progressAngle=2*pi*progressPercent;
    canvas.drawArc(new Rect.fromCircle(center: center,radius: radius), -pi/2, progressAngle, false, progressPaint);

    //paint thumb
    final thumbAngle=2*pi*thumbPosition-(pi/2);
    final thumbRadius=thumbSize/2.0;
    final thumbCenter=new Offset(cos(thumbAngle)*radius, sin(thumbAngle)*radius) +center;
    canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}


