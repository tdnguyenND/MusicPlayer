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
        return Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.black, width: 1)),
            ),
            child: Text(snapshot.error.toString()));
      }
      if (snapshot.hasData) {
        Metas metas = snapshot.data.metas;
        return Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.black, width: 1)),
            ),child: PlayingSongCard(metas: metas));
      }
      return Container();
    });
  }
}
