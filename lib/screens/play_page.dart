import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    AssetsAudioPlayer player = Provider.of<AssetsAudioPlayer>(context);
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder<Audio>(
          stream: player.current.map((playing) {
            if (playing == null) return null;

            // return Audio directly instead of instance of Playing
            return playing.audio.audio;
          }),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Something went wrong!');
            if (snapshot.hasData) {
              Audio data = snapshot.data;
              return Text(data.metas.title);
            }
            return Text('There are no song playing');
          },
        ));
  }
}
