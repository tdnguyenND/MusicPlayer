import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/services/firestore/fetch_data.dart';
import 'package:music_player/services/shazam.dart';
import 'package:music_player/widgets/search_by_single_field_result_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool loading = false;
  String searchKey;

  Widget searchResult;

  List<SongDetail> searchByNameResult;
  List<SongDetail> searchByAlbumResult;
  List<SongDetail> searchByArtistResult;

  TextEditingController _controller = TextEditingController();
  List<String> img = [
    'assets/genre.png',
    'assets/genre.png',
    'assets/genre.png',
    'assets/genre.png',
    'assets/genre.png',
    'assets/genre.png',
    'assets/genre.png',
    'assets/genre.png',
    'assets/genre.png',
    'assets/genre.png',
    'assets/genre.png'
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xFF191414),
              Color(0xFF1ED760),
              Color(0xFF1db954),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topRight,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 70,
              ),
              Text(
                'Tìm kiếm',
                style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.white.withOpacity(0.95),
                child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      isDense: true,
                      hintText: "Nghệ sĩ, bài hát, hoặc podcast",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(searchAndShowResult);
                        },
                      ),
                    ),
                    onChanged: (value) {
                      searchKey = value;
                      searchAndShowResult();
                    },
                    controller: _controller,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    )),
              ),
              Card(
                child: FlatButton(
                  child: Text('shazam'),
                  onPressed: () {
                    Navigator.push<Map>(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SongDetector()))
                        .then((value) {
                      updateWithSearchKey(value['title']);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Duyệt tìm tất cả',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: loading
                    ? SpinKitCircle(
                        color: Colors.black,
                      )
                    : searchResult ??
                        GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (170 / 100),
                          children: List.generate(img.length, (index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                child:
                                    Image.asset(img[index], fit: BoxFit.cover),
                              ),
                            );
                          }),
                        ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateWithSearchKey(String _searchKey) {
    _controller.text = _searchKey;
    searchKey = _searchKey;
    searchAndShowResult();
  }

  void searchAndShowResult() async {
    if (searchKey == null || searchKey.length == 0) return;
    setState(() {
      loading = true;
    });
    searchByNameResult = await searchSongByName(searchKey);
    searchByAlbumResult = await searchSongByAlbum(searchKey);
    searchByArtistResult = await searchSongByArtist(searchKey);

    showSearchResult();
    setState(() {
      loading = false;
    });
  }

  void showSearchResult() {
    searchResult = null;
    SearchBySingleFieldResultWidget name = SearchBySingleFieldResultWidget(
      searchResult: searchByNameResult,
      field: 'name',
      value: searchKey,
    );
    SearchBySingleFieldResultWidget album = SearchBySingleFieldResultWidget(
      searchResult: searchByAlbumResult,
      field: 'album',
      value: searchKey,
    );
    SearchBySingleFieldResultWidget artist = SearchBySingleFieldResultWidget(
      searchResult: searchByArtistResult,
      field: 'artist',
      value: searchKey,
    );
    searchResult = ListView(
      children: [
        name,
        album,
        artist,
      ],
    );
  }
}

class SongDetector extends StatefulWidget {
  @override
  _SongDetectorState createState() => _SongDetectorState();
}

class _SongDetectorState extends State<SongDetector> {
  ShazamService shazamService;
  Map result;
  Widget detectingResult = Container();

  @override
  void initState() {
    shazamService = ShazamService();
    Permission.microphone.request();
    super.initState();
  }

  Future<ShazamService> future() async {
    return shazamService;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Detect Song')),
        body: Center(
            child: StreamBuilder<ShazamServiceStatus>(
                stream: shazamService.onStatusChanged,
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData)
                    return Text('Something went wrong');
                  ShazamServiceStatus status = snapshot.data;
                  if (status == ShazamServiceStatus.INITIALIZING) {
                    return SpinKitCircle(
                      color: Colors.black,
                    );
                  } else if (status == ShazamServiceStatus.UNAVAILABLE) {
                    return Center(
                        child: Text('This feature is not available for now'));
                  } else if (status == ShazamServiceStatus.DETECTING ||
                      status == ShazamServiceStatus.SONG_FOUND) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                            onPressed: shazamService.stopDetecting,
                            child: Text('Cancel')),
                        Text('Detecting'),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        detectingResult,
                        IconButton(
                            icon: Icon(Icons.mic),
                            onPressed: () async {
                              setState(() {
                                detectingResult = Container();
                                shazamService.startDetecting().then((value) {
                                  result = value;
                                  detectingResult = result == null
                                      ? Text('Not found! Please try again')
                                      : Column(
                                          children: [
                                            Text(result['title']),
                                            Text(result['subtitle']),
                                            RaisedButton(
                                              onPressed: () {
                                                Navigator.pop(context, result);
                                              },
                                              child:
                                                  Text('Search for this title'),
                                            )
                                          ],
                                        );
                                });
                              });
                            }),
                      ],
                    );
                  }
                })));
  }
}
