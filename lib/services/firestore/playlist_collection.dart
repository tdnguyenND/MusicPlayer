import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_player/models/playlist_detail.dart';
import 'package:music_player/services/firestore/song_collection.dart';

import 'shared.dart';

class PlaylistFirestore {
  static final CollectionReference playlistRef =
      firebaseFirestore.collection(playlistCollectionName);

  static const String listSongsFieldName = 'listSongs';

  static Future<void> matchAllReferenceKey(Map<String, dynamic> data) async {
    return await matchReferenceKey(
        data, listSongsFieldName, SongFirestore.getSongById);
  }

  static Future<PlaylistDetail> getPlaylistById(String id) async {
    DocumentSnapshot snapshot = await playlistRef.doc(id).get();
    Map<String, dynamic> data = snapshot.data();
    await matchAllReferenceKey(data);
    PlaylistDetail res = PlaylistDetail.fromMapWithouId(data);
    res.id = id;
    return snapshot.exists ? res : null;
  }

  static Future<void> create(PlaylistDetail playlistDetail) {
    return playlistRef.add(playlistDetail.serializerWithoutID());
  }

  static Future<void> remove(String id) {
    return playlistRef.doc(id).delete();
  }

  static Stream<List<PlaylistDetail>> getPlaylistsOfUser(String uid) {
    return playlistRef.get().asStream().map((QuerySnapshot snapshot) {
      List<QueryDocumentSnapshot> docs = snapshot.docs;
      List<PlaylistDetail> res = [];
      for (DocumentSnapshot doc in docs) {
        if (doc.data()['uid'] == uid) {
          Map<String, dynamic> data = doc.data();
          matchReferenceKey(data, 'listSongs', SongFirestore.getSongById)
              .then((value) {
            PlaylistDetail detail = PlaylistDetail.fromMapWithouId(data);
            detail.id = doc.id;
            res.add(detail);
          });
        }
      }
      return res;
    });
  }

  static Future<void> addSongToPlaylist(String playlistId, String songId) {
    return playlistRef.doc(playlistId).update({
      listSongsFieldName: FieldValue.arrayUnion([songId])
    });
  }

  static Future<void> removeSongFromPlaylist(String playlistId, String songId) {
    return playlistRef.doc(playlistId).update({
      listSongsFieldName: FieldValue.arrayRemove([songId])
    });
  }

  static Future<bool> isSongExistedInPlaylist(
      String playlistId, String songId) async {
    DocumentSnapshot snapshot = await playlistRef.doc(playlistId).get();
    if (snapshot.exists) {
      List<String> listSongs = snapshot.data()[listSongsFieldName];
      return listSongs != null &&
          listSongs is List &&
          listSongs.contains(songId);
    } else
      return false;
  }

  static Future<void> addOrRemoveSongInPlaylist(
      String playlistId, String songId) async {
    if (await isSongExistedInPlaylist(playlistId, songId))
      removeSongFromPlaylist(playlistId, songId);
    else
      addSongToPlaylist(playlistId, songId);
  }
}
