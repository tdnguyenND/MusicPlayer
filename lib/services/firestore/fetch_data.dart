import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_player/models/playlist_detail.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/shared/support_function.dart';
import 'references.dart';

Future<List<SongDetail>> getAllSong() async {
  return (await songItemDetails.get())
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
  for (var element in tenElementsLists){
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