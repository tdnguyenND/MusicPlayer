import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/services/firestore/fetch_data.dart';
import 'package:music_player/widgets/list_song_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<SongDetail> allSongs;

  void loadSong() async {
    allSongs = await getAllSongOrderByName();
    setState(() {});
  }

  @override
  void initState() {
    loadSong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return allSongs == null
        ? SpinKitCircle(
            color: Colors.black,
          )
        : SingleChildScrollView(
          child: ListSongWidget(
              listSongDetails: allSongs,
            ),
        );
  }
}
