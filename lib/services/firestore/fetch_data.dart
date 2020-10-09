import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_player/models/playlist_detail.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/shared/support_function.dart';
import 'references.dart';

Future<List<SongDetail>> getAllSongOrderByName() async {
  return (await songItemDetails.orderBy('name').get())
      .docs
      .map(_songDetailFromQueryDocumentSnapshot)
      .toList();
}

Stream<List<PlaylistDetail>> userPlaylists(String uid) {
  return playlistCollection
      .where('uid', isEqualTo: uid)
      .get()
      .asStream()
      .map(_listOfPlaylistFromQuerySnapshot);
}

Future<List<SongDetail>> getSongOfPlaylist(String playlistId) async {
  List<String> listSongID = await _getSongIdBelongToPlaylist(playlistId);
  return _listSongDetailFromListSongId(listSongID);
}

Future<List<SongDetail>> searchSongByName(String name) async {
  return await _searchSongByField('name', name);
}

Future<List<SongDetail>> searchSongByArtist(String artist) async {
  return await _searchSongByField('artist', artist);
}

Future<List<SongDetail>> searchSongByAlbum(String album) async {
  return await _searchSongByField('album', album);
}

Future<PlaylistDetail> getLovedSongAsPlaylist(String uid) async {
  List<String> listSongId =
      List<String>.from((await userData.doc(uid).get()).data()['loveSong']);
  List<SongDetail> songDetails =
      await _listSongDetailFromListSongId(listSongId);
  return PlaylistDetail(name: 'Loved song', songDetails: songDetails);
}

Future<List<SongDetail>> _searchSongByField(String field, String value) async {
  List<SongDetail> songCatalog = await getAllSongOrderByName();
  final List<SongDetail> result = songCatalog
      .where((SongDetail songDetail) =>
          matchWithoutCaseSensitive(value, songDetail.toMap()[field]))
      .toList();
  return result;
}

SongDetail _songDetailFromQueryDocumentSnapshot(
    QueryDocumentSnapshot snapshot) {
  SongDetail res = SongDetail.fromMap(snapshot.data());
  res.id = snapshot.id;
  return res;
}

Future<List<String>> _getSongIdBelongToPlaylist(String playlistId) async {
  return (await songToPlaylist.where('playlistId', isEqualTo: playlistId).get())
      .docs
      .map((doc) => doc.data()['songId'].toString())
      .toList();
}

Future<List<SongDetail>> _listSongDetailFromListSongId(
    List<String> songIds) async {
  if (songIds == null || songIds.isEmpty) return [];
  List tenElementsLists = splitList(songIds);
  List<SongDetail> result = [];
  for (var element in tenElementsLists) {
    result.addAll((await songItemDetails
            .where(FieldPath.documentId, whereIn: element)
            .get())
        .docs
        .map(_songDetailFromQueryDocumentSnapshot)
        .toList());
  }
  return result;
}

List<PlaylistDetail> _listOfPlaylistFromQuerySnapshot(
    QuerySnapshot querySnapshot) {
  return querySnapshot.docs.map(_playlistDetailFromDocumentSnapshot).toList();
}

PlaylistDetail _playlistDetailFromDocumentSnapshot(DocumentSnapshot doc) {
  return PlaylistDetail(
      id: doc.id, uid: doc.data()['uid'], name: doc.data()['name']);
}
