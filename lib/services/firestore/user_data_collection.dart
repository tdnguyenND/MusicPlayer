import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_player/models/playlist_detail.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/models/user_data.dart';
import 'package:music_player/services/firestore/song_collection.dart';

import 'shared.dart';

class UserDataFirestore {
  static final CollectionReference userDataRef =
      firebaseFirestore.collection(userDataCollectionName);

  static const loveSongsFieldName = 'loveSong';

  static Future<void> matchAllReferenceKey(Map<String, dynamic> data) async {
    return await matchReferenceKey(
        data, loveSongsFieldName, SongFirestore.getSongById);
  }

  /// return instance of [UserData] if exist, [null] otherwise
  static Future<UserData> getUserDataById(String uid) async {
    DocumentSnapshot snapshot = await userDataRef.doc(uid).get();
    if (!snapshot.exists) return null;
    Map<String, dynamic> data = snapshot.data();
    await matchAllReferenceKey(data);
    UserData res = UserData.fromMapWithouId(data);
    res.id = uid;
    return res;
  }

  /// create a new document
  /// and return an instance of [UserData]
  static Future<UserData> create(UserData userData) async {
    String uid = userData.id;
    await userDataRef.doc(uid).set(userData.serializerWithoutID());
    return getUserDataById(uid);
  }

  /// return true if [UserData] with given id exist, false otherwise
  static Future<bool> existById(String uid) async {
    return (await userDataRef.doc(uid).get()).exists;
  }

  /// check if [UserData] is existed
  /// create a new document if not exist
  /// return an instance of [UserData]
  static Future<UserData> initUserData(String uid) async {
    if (!(await existById(uid))) {
      UserData userData = UserData(id: uid, loveSong: []);
      return await create(userData);
    } else
      return getUserDataById(uid);
  }

  static Future<PlaylistDetail> getLoveSongsAsPlaylist(String uid) async {
    UserData userData = await initUserData(uid);
    return PlaylistDetail(
        uid: uid, name: 'Love song', listSongs: userData.loveSong);
  }

  static Future<void> addSongToLoveSongs(String uid, String songId) {
    return userDataRef.doc(uid).update({
      loveSongsFieldName: FieldValue.arrayUnion([songId])
    });
  }

  static Future<void> removeFromLoveSongs(String uid, String songId) {
    return userDataRef.doc(uid).update({
      loveSongsFieldName: FieldValue.arrayRemove([songId])
    });
  }

  static Future<bool> isSongExistedInLoveSongs(
      String uid, String songId) async {
    UserData userData = await initUserData(uid);
    for (SongDetail songDetail in userData.loveSong) {
      if (songDetail.id == songId) return true;
    }
    return false;
  }

  static Future<void> addOrRemoveSongInLoveSongs(
      String uid, String songId) async {
    if (await isSongExistedInLoveSongs(uid, songId))
      removeFromLoveSongs(uid, songId);
    else
      addSongToLoveSongs(uid, songId);
  }
}
