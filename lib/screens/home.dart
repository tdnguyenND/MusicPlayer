import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_player/models/playlist_detail.dart';
import 'package:music_player/services/firestore/fetch_data.dart';
import 'package:music_player/widgets/playlist_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PlaylistDetail allSongs = PlaylistDetail();

  void loadSong() async {
    allSongs.songDetails = await getAllSong();
    setState(() {});
  }

  @override
  void initState() {
    loadSong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return allSongs.songDetails == null
        ? SpinKitCircle(
            color: Colors.black,
          )
        : PlaylistWidget(
            playlistDetail: allSongs,
          );
  }
}
