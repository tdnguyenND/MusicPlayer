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
      children: [Text('Search result for $field'), content],
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
                  FlatButton(
                    child: Text('View all'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => _fullScreen(context)));
                    },
                  )
                ],
          )
        : ListSongWidget(
            listSongDetails: searchResult,
          );
  }

  Widget _fullScreen(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search result for $field'),
        ),
        body: SingleChildScrollView(
          child: ListSongWidget(
            listSongDetails: searchResult,
          ),
        ));
  }
}
