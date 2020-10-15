import 'package:flutter/material.dart';
import 'package:music_player/models/song_detail.dart';
import 'list_song_widget.dart';

class SearchBySingleFieldResultWidget extends StatefulWidget {
  final List<SongDetail> searchResult;
  final String field;
  final String value;

  SearchBySingleFieldResultWidget({
    @required this.searchResult,
    @required this.field,
    @required this.value,
  });

  @override
  _SearchBySingleFieldResultWidgetState createState() =>
      _SearchBySingleFieldResultWidgetState();
}

class _SearchBySingleFieldResultWidgetState
    extends State<SearchBySingleFieldResultWidget> {
  List<SongDetail> searchResult;
  static final limit = 3;
  Text title;

  @override
  void initState() {
    searchResult = widget.searchResult;
    title = Text('Search result for ${widget.field}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _contentAsWidget();
    return Column(
      children: [title, content],
    );
  }

  Widget _contentAsWidget() {
    return searchResult.isEmpty ? _noResultView() : _haveResultView();
  }

  Widget _noResultView() {
    return Text(
        'There are no songs that ${widget.field} match with \"${widget.value}\"');
  }

  Widget _haveResultView() {
    return widget.searchResult.length >= limit
        ? Column(
            children: <Widget>[
                  ListSongWidget(
                      listSongDetails: searchResult.sublist(0, limit))
                ] +
                [
                  FlatButton(
                    child: Text('View all'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => _fullScreen()));
                    },
                  )
                ],
          )
        : ListSongWidget(
            listSongDetails: searchResult,
          );
  }

  Widget _fullScreen() {
    return Scaffold(
      appBar: AppBar(
        title: title,
      ),
      body: SingleChildScrollView(
        child: ListSongWidget(listSongDetails: searchResult,),
      )
    );
  }
}
