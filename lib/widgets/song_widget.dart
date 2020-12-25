import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_player/models/playlist_detail.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/services/firestore/playlist_collection.dart';
import 'package:music_player/services/firestore/user_data_collection.dart';
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
    playlist = Provider.of<List<Audio>>(context);
    player = Provider.of<AssetsAudioPlayer>(context);

    return Container(
      margin: EdgeInsets.all(4),
      width: 380,
      height: 76,
      child: Card(
        color: Colors.grey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Container(
                width: 70,
                height: 70,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(5)),
                  child: Image.network(
                    detail.imageUrl,
                    fit: BoxFit.cover,
                  ),
                )),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 220,
              height: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Text(
                      detail.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    detail.artist,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(fontSize: 14, color: Color(0xFFC4C4C4)),
                  )
                ],
              ),
            ),
            Container(
              width: 25,
              child: IconButton(
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                  iconSize: 30,
                  onPressed: () {
                    playlist.shuffle();
                    playlist.insert(0, detail.toAudio());
                    // remove duplicates
                    playlist = playlist.toSet().toList();
                    player.open(Playlist(audios: playlist, startIndex: 0),
                        autoStart: true, showNotification: true);
                  }),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              width: 25,
              child: IconButton(
                  iconSize: 30,
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _selectOption(context);
                  }),
            )
          ],
        ),
      ),
    );
  }

  void _selectOption(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: 180,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        child: Image.network(detail.imageUrl),
                        width: 120,
                        height: 120,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        detail.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        detail.artist,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                ),
                FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.favorite,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Like',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  onPressed: () {
                    if (user != null) {
                      UserDataFirestore.addOrRemoveSongInLoveSongs(
                          user.uid, detail.id);
                    } else
                      Fluttertoast.showToast(msg: 'Please log in first');
                  },
                ),
                FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Icon(
                            Icons.playlist_add,
                            color: Colors.green,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Add to playlist',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      selectPlaylistToAdd(context);
                    }),
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
            stream: PlaylistFirestore.getPlaylistsOfUser(user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text('Something went wrong');
              if (snapshot.hasData) {
                Future<List<PlaylistDetail>> userPlaylist = snapshot.data;
                return FutureBuilder(future: userPlaylist, builder: (context, snapshot){
                  List<PlaylistDetail> userPlaylist = snapshot.data;
                  return !snapshot.hasData
                    ? Text('You don\'t have any playlist yet')
                    : Column(
                        children: userPlaylist.map((playlistDetail) {
                          return FlatButton(
                            child: Text(playlistDetail.name),
                            onPressed: () async {
                              try {
                                await PlaylistFirestore
                                    .addOrRemoveSongInPlaylist(
                                        playlistDetail.id, detail.id);
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
                });
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
