import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_player/models/playlist_detail.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/widgets/list_song_widget.dart';

class PlaylistWidget extends StatefulWidget {
  final PlaylistDetail playlistDetail;

  PlaylistWidget({@required this.playlistDetail});

  @override
  _PlaylistWidgetState createState() => _PlaylistWidgetState();
}

class _PlaylistWidgetState extends State<PlaylistWidget> {
  PlaylistDetail playlistDetail;
  List<SongDetail> listSongDetails;

  @override
  void initState() {
    playlistDetail = widget.playlistDetail;
    listSongDetails = playlistDetail.listSongs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (listSongDetails != null) {
      return Scaffold(
          body: Container(
            color: Color(0xFF121212),
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[                      
                      Container(
                        width: 24,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(width: 30),
                      Container(
                        width: 280,
                        child: Text(playlistDetail.name ?? 'Playlist name',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        width: 24,
                        child: IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 24,
                        child: IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ]
                ),
                SizedBox(height: 24),
                SizedBox(width: 24),
                SizedBox(
                  width: 200,
                  child: Image.asset('assets/img2.jpg'),
                ),
                SizedBox(height: 24),
                Text(playlistDetail.name ?? 'Playlist name',
                  style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                ListSongWidget(
                  listSongDetails: listSongDetails,
                  playable: true,
                ),
            ],)
            ),
          );
    } else
      return SpinKitCircle(
        color: Colors.black,
      );
  }
}
