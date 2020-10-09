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

  Widget searchResult = Container();
  Widget searchByNameResultWidget;
  Widget searchByArtirstResultWidget;
  Widget searchByAlbumResultWidget;

  List<SongDetail> searchByNameResult;
  List<SongDetail> searchByAlbumResult;
  List<SongDetail> searchByArtistResult;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Form(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 9,
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Search for music, artist, and album'),
                          onChanged: (value) {
                            searchKey = value;
                            setState(searchAndShowResult);
                          },
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            setState(searchAndShowResult);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            loading
                ? SpinKitCircle(
                    color: Colors.black,
                  )
                : Expanded(child: searchResult)
          ],
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
    searchResult = 
    ListView(
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
