import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class PlayPage extends StatefulWidget {
  @override
  _PlayPageState createState() => _PlayPageState();
}

/// Use [Provider] to get player
/// Structure: AssetsAudioPlayer player = Provider.of<AssetsAudioPlayer>(context);
/// Then use AssetsAudioPlayer function to control music:
///   - next()
///   - prev()
///   - pause()
///   - play()
///   - playOrPause()
///   - seek(position)
/// For more detail visit https://pub.dev/packages/assets_audio_player

/// About song detail to render: use snapshot of player.current
/// Structure: snapshot.audio.audio
/// (in this case i use map to return Audio directly in stream in StreamBuilder)
/// For example:
///   - Get the name of current playing song: snapshot.audio.audio.metas.title
///     (or use shortcut in the case where stream return Audio instead: snapshot.metas.title)
///   - Or use class SongDetail: snapshot.audio.audio.metas.extra['detail'].name
///     (shortcut snapshot.metas.extra['detail'].name)

class _PlayPageState extends State<PlayPage> {
  String timeFormatter(double time) {
    Duration duration = Duration(seconds: time.round());
    if (duration.inHours > 0)
      return [duration.inHours, duration.inMinutes, duration.inSeconds]
          .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
          .join(':');
    else
      return [duration.inMinutes, duration.inSeconds]
          .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
          .join(':');
  }

  GlobalKey _keyContain = GlobalKey();

  double getContainWidth() {
    RenderBox box = _keyContain.currentContext.findRenderObject();
    double width = box.size.width;
    return width;
  }

  double getWidth(double current, double total) {
    double width = getContainWidth();
    return (current / total) * width;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    getContainWidth();
  }

  @override
  Widget build(BuildContext context) {
    AssetsAudioPlayer player = Provider.of<AssetsAudioPlayer>(context);
    bool seeking = false;
    Duration currentPosition;

    return StreamBuilder<Audio>(
      stream: player.current.map((playing) {
        if (playing == null) return null;

        //return Audio directly instead of instance of Playing
        return playing.audio.audio;
      }),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Something went wrong!');
        if (snapshot.hasData) {
          Audio data = snapshot.data;
          String path = data.metas.image.path ??
              'https://upload.wikimedia.org/wikipedia/vi/e/e4/Taylor_Swift_Red.jpg';
          return Scaffold(
            body: new Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Color(0xff191414),
                  Color(0xFF1db954),
                  Color(0xff191414),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topLeft,
              )),
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(   
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,                 
                    children: <Widget>[                      
                      Container(
                        width: 24,
                        child: IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Text(
                        data.metas.artist,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                      ),
                      Container(
                        width: 24,
                        child: Icon(Icons.more_vert, color: Colors.white, size: 24)),
                    ],
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: 280,
                    child: Image.network(path),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    data.metas.title,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    data.metas.artist,
                    style: TextStyle(fontSize: 18, color: Colors.white54),
                  ),
                  SizedBox(height: 10),
                  StreamBuilder<Duration>(
                    stream: player.currentPosition,
                    builder: (context, snapshot) {
                      if (!seeking) currentPosition = snapshot.data;
                      return Column(
                        children: [
                          Stack(
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 1,
                                ),
                                child: Slider(
                                  value: currentPosition.inSeconds.toDouble(),
                                  min: 0.0,
                                  max: player
                                      .current.value.audio.duration.inSeconds
                                      .toDouble(),
                                  activeColor: Colors.blue,
                                  inactiveColor: Colors.white,
                                  divisions: player
                                      .current.value.audio.duration.inSeconds,
                                  onChanged: (value) {
                                    seeking = true;
                                    currentPosition =
                                        Duration(seconds: value.toInt());
                                  },
                                  onChangeEnd: (value) {
                                    seeking = false;
                                    player
                                        .seek(Duration(seconds: value.toInt()));
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                timeFormatter(
                                    currentPosition.inSeconds.roundToDouble()),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(250, 250, 250, 0.46)),
                              ),
                              Text(
                                timeFormatter(player
                                    .current.value.audio.duration.inSeconds
                                    .roundToDouble()),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(250, 250, 250, 0.46)),
                              )
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        child: IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.white54,
                            ),
                            onPressed: null),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        child: IconButton(
                            icon: Icon(
                              Icons.skip_previous,
                              color: Color.fromRGBO(250, 250, 250, 0.95),
                              size: 50,
                            ),
                            onPressed: (){
                              player.previous();
                            }),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        child: IconButton(
                            icon: Icon(
                              player.isPlaying.value
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              size: 70,
                              color: Color.fromRGBO(250, 250, 250, 0.95),
                            ),
                            onPressed: () async {
                              await player.playOrPause();
                              setState(() {});
                            }),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        child: IconButton(
                            icon: Icon(
                              Icons.skip_next,
                              color: Color.fromRGBO(250, 250, 250, 0.95),
                              size: 50,
                            ),
                            onPressed: (){
                              player.next();
                            }),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        child: IconButton(
                            icon: Icon(
                              Icons.remove_circle_outline_outlined,
                              color: Colors.white54,
                            ),
                            onPressed: (){}),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
        return Text('There are no song playing');
      },
    );
  }
}
