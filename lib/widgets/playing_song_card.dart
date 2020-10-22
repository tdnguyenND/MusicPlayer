import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/screens/play_page.dart';
import 'package:provider/provider.dart';

/// The bottom bar of current playing song
class PlayingSongCard extends StatefulWidget {
  final Metas metas;

  PlayingSongCard({@required this.metas});

  @override
  _PlayingSongCardState createState() => _PlayingSongCardState();
}

class _PlayingSongCardState extends State<PlayingSongCard> {
  @override
  Widget build(BuildContext context) {
    Metas metas = widget.metas;
    AssetsAudioPlayer player = Provider.of<AssetsAudioPlayer>(context);
    return FlatButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PlayPage()));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(metas.title),
            StreamBuilder<bool>(
              stream: player.isPlaying,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return IconButton(
                    onPressed: player.playOrPause,
                    icon: Icon(snapshot.data ? Icons.pause : Icons.play_arrow),
                  );
                else
                  return Container();
              },
            )
          ],
        ));
  }
}
