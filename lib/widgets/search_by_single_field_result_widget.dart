import 'package:flutter/material.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/widgets/song_widget.dart';

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
  @override
  void initState() {
    searchResult = widget.searchResult;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Text title = Text('Search result for ${widget.field}');
    Widget content = _contentAsWidget();
    return Container(
      child: Column(
        children: [title, content],
      ),
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
    return (widget.searchResult.length >= limit
        ? Column(
            children: searchResult
                    .sublist(0, limit)
                    .map(_singleResultToWidget)
                    .toList() +
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
        : Column(
            children: searchResult.map(_singleResultToWidget).toList(),
          ));
  }

  Widget _singleResultToWidget(SongDetail singleResult) {
    return SongWidget(
      songDetail: singleResult,
      playRight: false,
    );
  }

  Widget _fullScreen() {
    return Stack(
      children: [
        ListView(
          children: searchResult.map(_singleResultToWidget).toList(),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: AppBar(
            title: Text('something'),
            elevation: 0.0,
          ),
        )
      ],
    );
  }
}
