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

  void loadSong() async {
    await playlistDetail.fetchSongs();
    setState(() {
      playlistDetail = widget.playlistDetail;
      listSongDetails = playlistDetail.songDetails;
    });
  }

  @override
  void initState() {
    playlistDetail = widget.playlistDetail;
    listSongDetails = playlistDetail.songDetails;
    loadSong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (listSongDetails != null) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF191414),
            leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
                },
            ),
            title: Text(playlistDetail.name ?? 'Playlist name'),
            actions: [
        IconButton(
        onPressed:(){} ,
        icon: Icon(Icons.favorite_border),),
        IconButton(
        onPressed:(){} ,
        icon: Icon(Icons.more_vert),),
            ],
            
          ),
          body: Container(
            decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: [
              Color(0xff191414),
              Color(0xFF1db954),
              Color(0xff191414),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topLeft,
              )),
          child: ListView(
        children: [
            SingleChildScrollView(
            child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height:20),
                Container(width: 200, height:200, color:Colors.white),
                SizedBox(height:20),
                Text(playlistDetail.name.toUpperCase() ?? 'Playlist name',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                ),),
                SizedBox(height:5),
                Text('get for '.toUpperCase(),
                style: TextStyle(fontSize: 18, color: Colors.white70),),
                //ten cua nguoi dung
                ListSongWidget(
                listSongDetails: listSongDetails,
                playable: true,
                  ),
          ],
        ),
              ),
      ],
          ),
        ));
    } else
      return SpinKitCircle(
        color: Colors.black,
      );
  }
}
