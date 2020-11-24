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
      color: Color(0xFF272727),
      padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PlayPage()));
        },
        child: Row(
          children: [
            Image.network(metas.image.path),
            SizedBox(width:10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 254,
                  child: Text(metas.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                Text(
                  metas.artist, 
                  style: TextStyle(fontSize: 14,
                  color: Color(0xFFC4C4C4)))
              ],
            ),
            SizedBox(width:18),
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
            
          ],
        ));
  }
}
