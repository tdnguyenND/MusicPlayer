import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/services/firestore/fetch_data.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AssetsAudioPlayer player = AssetsAudioPlayer();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: songCatalogStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.hasData) {
          List<SongDetail> songDetails = snapshot.data;
          List<Audio> playlist =
              songDetails.map((detail) => detail.audio).toList();
          return ListView.builder(
              itemCount: songDetails.length,
              itemBuilder: (context, index) {
                SongDetail songDetail = songDetails[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(songDetail.name),
                            Text(songDetail.album)
                          ],
                        ),
                        Text(songDetail.artist),
                        RaisedButton(
                          shape: CircleBorder(),
                          child: Icon(Icons.play_arrow),
                          onPressed: () {
                            playlist.shuffle();
                            playlist.insert(0, songDetail.audio);
                            // remove duplicates
                            playlist = playlist.toSet().toList();
                            player.open(
                              Playlist(audios: playlist, startIndex: 0),
                              autoStart: true,
                              showNotification: true,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                );
              });
        }
        return SpinKitRing(
          color: Colors.black,
        );
      },
    );
  }
}
