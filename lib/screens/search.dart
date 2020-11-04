import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/services/firestore/fetch_data.dart';
import 'package:music_player/widgets/search_by_single_field_result_widget.dart';

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
        // child: Column(
        //   children: [
        //     Container(
        //       child: Padding(
        //         padding:
        //             const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        //         child: Form(
        //           child: Row(
        //             children: [
        //               Flexible(
        //                 flex: 9,
        //                 child: TextFormField(
        //                   decoration: InputDecoration(
        //                       hintText: 'Search for music, artist, and album'),
        //                   onChanged: (value) {
        //                     searchKey = value;
        //                     setState(searchAndShowResult);
        //                   },
        //                 ),
        //               ),
        //               Flexible(
        //                 flex: 1,
        //                 child: IconButton(
        //                   icon: Icon(Icons.search),
        //                   onPressed: () {
        //                     setState(searchAndShowResult);
        //                   },
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //     loading
        //         ? SpinKitCircle(
        //             color: Colors.black,
        //           )
        //         : Expanded(child: searchResult)
        //   ],
        // ),
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