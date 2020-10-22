import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/widgets/song_widget.dart';
import 'package:provider/provider.dart';

class ListSongWidget extends StatefulWidget {
  final List<SongDetail> listSongDetails;
  final bool playable;

  ListSongWidget({@required this.listSongDetails, this.playable = false});
  @override
  _ListSongWidgetState createState() => _ListSongWidgetState();
}

class _ListSongWidgetState extends State<ListSongWidget> {
  List<SongDetail> listSongDetails;
  @override
  void initState() {
    this.listSongDetails = widget.listSongDetails;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (listSongDetails != null) {
      return listSongDetails.isNotEmpty
          ? Provider(
              create: (context) => listSongDetails
                  .map((SongDetail songDetail) => songDetail.toAudio())
                  .toList(),
              child: Column(
                children: listSongDetails
                    .map((SongDetail songDetail) => SongWidget(
                          songDetail: songDetail,
                          playRight: widget.playable,
                        ))
                    .toList(),
              ))
          : Center(
              child: Text('This playlist is empty'),
            );
    } else
      return SpinKitCircle(
        color: Colors.black,
      );
  }
}
