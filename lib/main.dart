import 'dart:math';

import 'bottom_controls.dart';
import 'package:flutter/material.dart';
import 'package:ss_player/songs.dart';
import 'package:ss_player/theme.dart';
import 'package:fluttery/gestures.dart';
import 'package:fluttery_audio/fluttery_audio.dart';

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
    return new AudioPlaylist(
      playlist:demoPlaylist.songs. map((DemoSong song){
          return song.audioUrl;
      }).toList(growable: false),
      playbackState: PlaybackState.paused,
      child: new Scaffold(
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
              child: new AudioPlaylistComponent(
                  playlistBuilder: (BuildContext context,Playlist playlist,Widget child){
                    String albumArtUrl=demoPlaylist.songs[playlist.activeIndex].albumArtUrl;

                    return new AudioRadialSeekBar(
                        albumArtUrl:albumArtUrl
                    );
                  },
              ),
            ),


            //visualizer
            new Container(
              width: double.infinity,
              height: 125.0,
              child: new Visualizer(
                builder: (BuildContext context,List<int> fft){
                  return new CustomPaint(
                      painter: new VisualizerPainter(
                        fft:fft,
                        height:125.0,
                        color:accentColor,
                      ),
                      child: new Container(),
                  );
                },
              ),
            ),

            //song details
            new BottomControls()
          ],
        ),
      ),
    );
  }
}


class VisualizerPainter extends CustomPainter {

  final List<int> fft;
  final double height;
  final Color color;
  final Paint wavePaint;

  VisualizerPainter({
    this.fft,
    this.height,
    this.color,
  }) : wavePaint = new Paint()
    ..color = color.withOpacity(0.75)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    _renderWaves(canvas, size);
  }

  void _renderWaves(Canvas canvas, Size size) {
    final histogramLow = _createHistogram(fft, 15, 2, ((fft.length) / 4).floor());
    final histogramHigh = _createHistogram(fft, 15, (fft.length / 4).ceil(), (fft.length / 2).floor());

    _renderHistogram(canvas, size, histogramLow);
    _renderHistogram(canvas, size, histogramHigh);
  }

  void _renderHistogram(Canvas canvas, Size size, List<int> histogram) {
    if (histogram.length == 0) {
      return;
    }

    final pointsToGraph = histogram.length;
    final widthPerSample = (size.width / (pointsToGraph - 2)).floor();

    final points = new List<double>.filled(pointsToGraph * 4, 0.0);

    for (int i = 0; i < histogram.length - 1; ++i) {
      points[i * 4] = (i * widthPerSample).toDouble();
      points[i * 4 + 1] = size.height - histogram[i].toDouble();

      points[i * 4 + 2] = ((i + 1) * widthPerSample).toDouble();
      points[i * 4 + 3] = size.height - (histogram[i + 1].toDouble());
    }

    Path path = new Path();
    path.moveTo(0.0, size.height);
    path.lineTo(points[0], points[1]);
    for (int i = 2; i < points.length - 4; i += 2) {
      path.cubicTo(
          points[i - 2] + 10.0, points[i - 1],
          points[i] - 10.0, points [i + 1],
          points[i], points[i + 1]
      );
    }
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, wavePaint);
  }

  List<int> _createHistogram(List<int> samples, int bucketCount, [int start, int end]) {
    if (start == end) {
      return const [];
    }

    start = start ?? 0;
    end = end ?? samples.length - 1;
    final sampleCount = end - start + 1;

    final samplesPerBucket = (sampleCount / bucketCount).floor();
    if (samplesPerBucket == 0) {
      return const [];
    }

    final actualSampleCount = sampleCount - (sampleCount % samplesPerBucket);
    List<int> histogram = new List<int>.filled(bucketCount, 0);

    // Add up the frequency amounts for each bucket.
    for (int i = start; i <= start + actualSampleCount; ++i) {
      // Ignore the imaginary half of each FFT sample
      if ((i - start) % 2 == 1) {
        continue;
      }

      int bucketIndex = ((i - start) / samplesPerBucket).floor();
      histogram[bucketIndex] += samples[i];
    }

    // Massage the data for visualization
    for (var i = 0; i < histogram.length; ++i) {
      histogram[i] = (histogram[i] / samplesPerBucket).abs().round();
    }

    return histogram;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}




class AudioRadialSeekBar extends StatefulWidget {

  final String albumArtUrl;

  AudioRadialSeekBar({
      this.albumArtUrl
  });

  @override
  _AudioRadialSeekBarState createState() => _AudioRadialSeekBarState();
}

class _AudioRadialSeekBarState extends State<AudioRadialSeekBar> {

  double _seekPercent;
  @override
  Widget build(BuildContext context) {
    return new AudioComponent(
                updateMe:[
                  WatchableAudioProperties.audioSeeking,
                  WatchableAudioProperties.audioPlayhead
                ],
                  playerBuilder:(BuildContext context,AudioPlayer player,Widget child){

                  double playBackProgress=0.0;
                  if(player.audioLength!=null && player.position!=null){
                        playBackProgress=player.position.inMilliseconds/player.audioLength.inMilliseconds;
                  }

                  _seekPercent=player.isSeeking ? _seekPercent:null;

                    return new RadialSeekBar(
                      progress: playBackProgress,
                      seekPercent:_seekPercent ,
                      onSeekRequested: (double seekPercent){
                        setState(() {
                          _seekPercent=seekPercent;
                          final seekMillis=(player.audioLength.inMilliseconds*seekPercent).round();
                          player.seek(new Duration(milliseconds: seekMillis));
                        });
                      },
                      child:new Container(
                        color: accentColor,
                        child: new Image.network(
                            widget.albumArtUrl,
                          fit: BoxFit.cover,
                        ),
                      )
                    );
                  },
              );
  }
}

class RadialSeekBar extends StatefulWidget {

  final double seekPercent;
  final double progress;
  final Function(double) onSeekRequested;
  final Widget child;

  RadialSeekBar({
    this.seekPercent=0.0,
    this.progress=0.0,
    this.onSeekRequested,
    this.child
  });

  @override
  _RadialSeekBarState createState() => _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {

  PolarCoord _startDragCoord;
  double _startDragPercent;
  double _progress=0.0;
  double _currentDragPercent;

  @override
  void initState() {
    super.initState();
    _progress=widget.progress;
  }

  @override
  void didUpdateWidget(RadialSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _progress=widget.progress;
  }

  void _onDragStart(PolarCoord coord){
    _startDragCoord=coord;
    _startDragPercent=_progress;

  }
  void _onDragUpdate(PolarCoord coord){
    final dragAngle=coord.angle-_startDragCoord.angle;
    final dragPercent=dragAngle/(2*pi);
    setState(() {
      _currentDragPercent=(_startDragPercent+dragPercent)%1.0;
    });

  }
  void _onDragEnd(){

    if(widget.onSeekRequested!=null){
      widget.onSeekRequested(_currentDragPercent);
    }

    setState(() {
      _currentDragPercent=null;
      _startDragPercent=0.0;
      _startDragCoord=null;
    });
  }



  @override
  Widget build(BuildContext context) {
    double thumbPosition=_progress;
    if(_currentDragPercent!=null){
      thumbPosition=_currentDragPercent;
    }
    else if(widget.seekPercent!=null){
      thumbPosition=widget.seekPercent;
    }

    return new RadialDragGestureDetector(
      onRadialDragStart:_onDragStart,
      onRadialDragUpdate: _onDragUpdate,
      onRadialDragEnd: _onDragEnd,
      child: new Container(
        width:double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: new Center(
          child: new Container(
            width: 140.0,
            height: 140.0,
            child: new RadialProgressBar(
              progressPercent:  _progress,
              thumbPosition: thumbPosition,
              innerPadding: EdgeInsets.all(10.0),
              progressColor: accentColor,
              thumbColor: lightAccentColor,
              trackColor: Colors.grey[300],
              child: new ClipOval(
                clipper: new CircleClipper(),
                child: widget.child,

              ),
            ),
          ),

        ),
      ),
    );
  }
}

class RadialProgressBar extends StatefulWidget {

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

  RadialProgressBar({
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
  _RadialProgressBarState createState() => _RadialProgressBarState();
}

class _RadialProgressBarState extends State<RadialProgressBar> {

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



