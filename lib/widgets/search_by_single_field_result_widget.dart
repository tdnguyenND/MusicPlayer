import 'package:flutter/material.dart';
import 'package:music_player/models/song_detail.dart';
import 'list_song_widget.dart';

class SearchBySingleFieldResultWidget extends StatelessWidget {
  final List<SongDetail> searchResult;
  final String field;
  final String value;
  static final limit = 3;

  SearchBySingleFieldResultWidget({
    @required this.searchResult,
    @required this.field,
    @required this.value,
  });
  @override
  Widget build(BuildContext context) {
    Widget content = _contentAsWidget(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            Text(
              'Search result for $field',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        content
      ],
    );
  }

  Widget _contentAsWidget(context) {
    return searchResult.isEmpty
        ? _noResultView(context)
        : _haveResultView(context);
  }

  Widget _noResultView(context) {
    return Text('There are no songs that $field match with \"$value\"');
  }

  Widget _haveResultView(context) {
    return searchResult.length >= limit
        ? Column(
            children: <Widget>[
                  ListSongWidget(
                      listSongDetails: searchResult.sublist(0, limit))
                ] +
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FlatButton(                  
                        color: Color(0x00000000),
                        child: Text('View all',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => _fullScreen(context)));
                        },
                      ),
                    ],
                  )
                ],
          )
        : ListSongWidget(
            listSongDetails: searchResult,
          );
  }

  Widget _fullScreen(context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 4),
                  IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                    Navigator.pop(context);
                  }, color: Colors.white),
                ],
              ),
              Row(                
                children: [
                  SizedBox(width: 18),
                  Text('Search result for $field',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 12),
                  ListSongWidget(
                    listSongDetails: searchResult,
                  ),
                ],
              ),
          ],
    )));
  }
}
