import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_player/models/song_detail.dart';
import 'references.dart';

Stream<List<SongDetail>> get songCatalogStream {
  return songItemDetails.snapshots().map(_listSongDetailFromQuerySnapshot);
}

List<SongDetail> _listSongDetailFromQuerySnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    dynamic data = doc.data();
    return SongDetail(
      name: data['name'],
      artist: data['artist'],
      album: data['album'],
      songUrl: data['songUrl'],
      imageUrl: data['imageUrl']
    );
  }).toList();
}
