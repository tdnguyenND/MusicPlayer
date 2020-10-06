import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/models/playlist_detail.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/services/firestore/fetch_data.dart';
import 'package:music_player/services/firestore/push_data.dart';
import 'package:provider/provider.dart';

class SongWidget extends StatefulWidget {
  final SongDetail songDetail;
  final bool playRight;

  SongWidget({this.songDetail, this.playRight = true});
  @override
  _SongWidgetState createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  SongDetail detail;
  User user;
  List<Audio> playlist;
  AssetsAudioPlayer player;
  @override
  void initState() {
    detail = widget.songDetail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    if (widget.playRight) {
      playlist = Provider.of<List<Audio>>(context);
      player = Provider.of<AssetsAudioPlayer>(context);
    }
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detail.name),
                Text(detail.artist),
                Text(detail.album)
              ],
            ),
            Row(
              children: [
                widget.playRight
                    ? RaisedButton(
                        shape: CircleBorder(),
                        child: Icon(Icons.play_arrow),
                        onPressed: () {
                          playlist.shuffle();
                          playlist.insert(0, detail.toAudio());
                          // remove duplicates
                          playlist = playlist.toSet().toList();
                          player.open(
                            Playlist(audios: playlist, startIndex: 0),
                            autoStart: true,
                            showNotification: true,
                          );
                        },
                      )
                    : Container(),
                RaisedButton(
                  shape: CircleBorder(),
                  child: Icon(Icons.more_vert),
                  onPressed: () {
                    selectOption(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void selectOption(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Column(
              children: [
                FlatButton(
                  child: Text('Add to playlist'),
                  onPressed: () {
                    if (user != null) {
                      selectPlaylistToAdd(context);
                    } else
                      Fluttertoast.showToast(msg: 'Please log in first');
                  },
                )
              ],
            ),
          );
        });
  }

  void selectPlaylistToAdd(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select playlist'),
          content: StreamBuilder(
            stream: userPlaylists(user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text('Something went wrong');
              if (snapshot.hasData) {
                List<PlaylistDetail> userPlaylist = snapshot.data;
                return userPlaylist == null
                    ? Text('You don\'t have any playlist yet')
                    : Column(
                        children: userPlaylist.map((playlistDetail) {
                          return FlatButton(
                            child: Text(playlistDetail.name),
                            onPressed: () async {
                              try {
                                await addSongToPlaylist(
                                    uid: user.uid,
                                    playlistId: playlistDetail.id,
                                    songId: detail.id);
                                Navigator.pop(context);
                              } catch (e) {
                                print(e);
                                Fluttertoast.showToast(
                                    msg:
                                        'This song is already in this playlist');
                              }
                            },
                          );
                        }).toList(),
                      );
              } else
                return SpinKitCircle(
                  color: Colors.black,
                );
            },
          ),
        );
      },
    );
  }
}
