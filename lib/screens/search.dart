import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/services/firestore/fetch_data.dart';
import 'package:music_player/widgets/search_by_single_field_result_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool loading = false;
  String searchKey;

  Widget searchResult;
  Widget searchByNameResultWidget;
  Widget searchByArtirstResultWidget;
  Widget searchByAlbumResultWidget;

  List<SongDetail> searchByNameResult;
  List<SongDetail> searchByAlbumResult;
  List<SongDetail> searchByArtistResult;
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
                      setState(searchAndShowResult);
                    },
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Recorder()));
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
                child: searchResult ??
                    GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (170 / 100),
                      children: List.generate(img.length, (index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            child: Image.asset(img[index], fit: BoxFit.cover),
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

  void searchAndShowResult() async {
    if (searchKey == null || searchKey.length == 0) return;
    setState(() {
      loading = true;
    });
    Future.wait([
      searchSongByName(searchKey).then((value) => searchByNameResult = value),
      searchSongByAlbum(searchKey).then((value) => searchByAlbumResult = value),
      searchSongByArtist(searchKey)
          .then((value) => searchByArtistResult = value),
    ]).then((value) => showSearchResult()).then((value) {
      setState(() {
        loading = false;
      });
    });
  }

  void showSearchResult() {
    searchResult = ListView(
      children: [
        SearchBySingleFieldResultWidget(
          searchResult: searchByNameResult,
          field: 'name',
          value: searchKey,
        ),
        SearchBySingleFieldResultWidget(
          searchResult: searchByAlbumResult,
          field: 'album',
          value: searchKey,
        ),
        SearchBySingleFieldResultWidget(
          searchResult: searchByArtistResult,
          field: 'artist',
          value: searchKey,
        ),
      ],
    );
  }
}

class Recorder extends StatefulWidget {
  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  String path;
  String data;
  String fileName = '/record.mp3';
  FlutterSoundRecorder recorder;

  String apiPath = 'https://shazam.p.rapidapi.com/songs/detect';
  String apiToken = 'cf0b683c0dmshfe84d1e62f43840p185a45jsn372db35a018e';

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    recorder = FlutterSoundRecorder();
    recorder.openAudioSession();
    data = '';
    path = (await getApplicationDocumentsDirectory()).path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Icon(Icons.mic),
          onPressed: () async {
            if (!recorder.isRecording) {
              recorder.startRecorder(
                  codec: Codec.pcm16,
                  toFile: path + fileName,
                  numChannels: 1,
                  sampleRate: 44100);
            } else {
              recorder.stopRecorder();
              detectThenDelete();
            }
          },
        ),
      ),
    );
  }

  void detectThenDelete() async {
    File file = File(path + fileName);
    List<int> audioBytes = file.readAsBytesSync();
    String base64 = Base64Encoder().convert(audioBytes);
    Response response = await post(apiPath,
        headers: {
          'x-rapidapi-host': "shazam.p.rapidapi.com",
          'x-rapidapi-key': apiToken,
          'content-type': "text/plain",
        },
        body: base64);
    print(response.body);
  }
}
