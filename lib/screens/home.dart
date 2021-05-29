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
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,                
                children: [
                  SizedBox(width: 20),
                  Text('Recently upload',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ListSongWidget(listSongDetails: latestUpload),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20),
                  Text('Top listen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              ListSongWidget(listSongDetails: topHit),
              SizedBox(height: 12),
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
        : homeBase;
  }
}
