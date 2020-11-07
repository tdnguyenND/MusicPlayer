import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/widgets/playing_song_card.dart';
import 'package:provider/provider.dart';

class BottomPlayingBar extends StatefulWidget {
  @override
  _BottomPlayingBarState createState() => _BottomPlayingBarState();
}

class _BottomPlayingBarState extends State<BottomPlayingBar> {
  @override
  Widget build(BuildContext context) {
    AssetsAudioPlayer player = Provider.of<AssetsAudioPlayer>(context);
    return StreamBuilder<Audio>(stream: player.current.map((Playing playing) {
      if (playing == null) return null;
      return playing.audio.audio;
    }), builder: (context, snapshot) {
      if (snapshot.hasError) {
        print(snapshot.error);
        return Text(snapshot.error.toString());
      }
      if (snapshot.hasData) {
        Metas metas = snapshot.data.metas;
        return PlayingSongCard(metas: metas);
      }
      return Container(
        color: Color(0xFF1db954),
        child: Center(
          child: Text('Your playing song here',
          style: TextStyle(color: Colors.white,
          fontSize: 16,
          letterSpacing: 0.5),)));
    });
  }
}
