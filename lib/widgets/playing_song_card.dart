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
      color: Colors.green,
      padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PlayPage()));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(metas.image.path),
            SizedBox(width:10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(metas.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),),
                Text(
                  metas.artist.toUpperCase(), 
                  style: TextStyle(fontSize: 18,
                  color: Colors.white60))
              ],
            ),
            SizedBox(width:120),
            Icon(Icons.favorite_border,
            color: Colors.white,),
            StreamBuilder<bool>(
              stream: player.isPlaying,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return IconButton(
                    onPressed: player.playOrPause,
                    color: Colors.white,
                    iconSize: 30,
                    icon: Icon(snapshot.data ? Icons.pause : Icons.play_arrow),
                  );
                else
                  return Container();
              },
            ),
            SizedBox(width:10)
          ],
        ));
  }
}
