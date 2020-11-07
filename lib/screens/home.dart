import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/services/firestore/song_collection.dart';
import 'package:music_player/widgets/list_song_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<SongDetail> latestUpload;
  List<SongDetail> topHit;

  Widget homeBase;

  void loadSong() async {
    Future.wait([
      SongFirestore.getUploadRecentlySong().then((value) {
        latestUpload = value;
      }),
      SongFirestore.getTopListenedSong().then((value) {
        topHit = value;
      })
    ]).then((value) {
      setState(() {
        homeBase = SingleChildScrollView(
          child: Column(
            children: [
              Text('Upload recently'),
              ListSongWidget(listSongDetails: latestUpload),
              Text('Top listen'),
              ListSongWidget(listSongDetails: topHit)
            ],
          ),
        );
      });
    });
  }

  @override
  void initState() {
    loadSong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return homeBase == null
        ? SpinKitCircle(
            color: Colors.black,
          )
        : SingleChildScrollView(
            child: homeBase,
          );
  }
}
