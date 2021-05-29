import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/shared/support_function.dart';

import 'shared.dart';

class SongFirestore {
  static final CollectionReference songRef =
      firebaseFirestore.collection(songCollectionName);

  static Future<SongDetail> getSongById(String id) async {
    DocumentSnapshot snapshot = await songRef.doc(id).get();
    SongDetail res = SongDetail.fromMapWithoutId(snapshot.data());
    res.id = id;
    return snapshot.exists ? res : null;
  }

  static Future<void> create(SongDetail songDetail) {
    return songRef.add(songDetail.serializerWithoutID());
  }

  static Future<List<SongDetail>> getTopListenedSong() async {
    return await getQuerySet(
        orderBy: ['-listenTime', 'name'], limit: chartLimit);
  }

  static Future<List<SongDetail>> getUploadRecentlySong() async {
    return await getQuerySet(orderBy: ['-created', 'name'], limit: chartLimit);
  }

  static Future<List<SongDetail>> searchSongByName(String name) async {
    return await _searchSongByField('name', name);
  }

  static Future<List<SongDetail>> searchSongByArtist(String artist) async {
    return await _searchSongByField('artist', artist);
  }

  static Future<List<SongDetail>> searchSongByAlbum(String album) async {
    return await _searchSongByField('album', album);
  }

  static Future<List<SongDetail>> getQuerySet(
      {List<String> orderBy = const [], int limit}) async {
    Query query = songRef;
    for (String field in orderBy) {
      if (field.startsWith('-')) {
        query = query.orderBy(field.substring(1), descending: true);
      } else {
        query = query.orderBy(field);
      }
    }
    if (limit != null) query = query.limit(limit);
    QuerySnapshot querySnapshot = await query.get();
    List<SongDetail> res = [];
    for (DocumentSnapshot snapshot in querySnapshot.docs) {
      SongDetail songDetail = SongDetail.fromMapWithoutId(snapshot.data());
      songDetail.id = snapshot.id;
      res.add(songDetail);
    }
    return res;
  }

  static Future<List<SongDetail>> _searchSongByField(
      String field, String value) async {
    List<SongDetail> songCatalog = await getQuerySet(orderBy: ['name']);
    final List<SongDetail> result = songCatalog
        .where((SongDetail songDetail) =>
            matchWithoutCaseSensitive(value, songDetail.toMap()[field]))
        .toList();
    return result ?? [];
  }

  static Future<SongDetail> increaseListenTime(String songId) {
    return songRef.doc(songId).update({'listenTime': FieldValue.increment(1)});
  }
}
