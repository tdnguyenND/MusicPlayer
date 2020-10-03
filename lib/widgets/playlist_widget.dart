import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_player/models/playlist_detail.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/widgets/song_widget.dart';
import 'package:provider/provider.dart';

class PlaylistWidget extends StatefulWidget {
  final PlaylistDetail playlistDetail;

  PlaylistWidget({this.playlistDetail});

  @override
  _PlaylistWidgetState createState() => _PlaylistWidgetState();
}

class _PlaylistWidgetState extends State<PlaylistWidget> {
  PlaylistDetail playlistDetail;
  List<SongDetail> listSongDetails;

  void loadSong() async {
    playlistDetail = widget.playlistDetail;
    await playlistDetail.fetchSongs();
    listSongDetails = playlistDetail.songDetails;
    setState(() {});
  }

  @override
  void initState() {
    loadSong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (listSongDetails != null) {
      return listSongDetails.isNotEmpty
          ? StreamProvider.value(
              value: Stream.fromFuture(playlistDetail.playlist),
              child: SingleChildScrollView(
                child: Column(
                  children: listSongDetails
                      .map((SongDetail songDetail) => SongWidget(
                            songDetail: songDetail,
                          ))
                      .toList(),
                ),
              ),
            )
          : Center(
              child: Text('This playlist is empty'),
            );
    } else
      return SpinKitCircle(
        color: Colors.black,
      );
  }
}
