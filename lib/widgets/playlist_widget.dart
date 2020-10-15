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
          title: Text(playlistDetail.name ?? 'Playlist name'),
        ),
        body: SingleChildScrollView(
          child: ListSongWidget(
          listSongDetails: listSongDetails,
        ),
        ),
      );
    } else
      return SpinKitCircle(
        color: Colors.black,
      );
  }
}
