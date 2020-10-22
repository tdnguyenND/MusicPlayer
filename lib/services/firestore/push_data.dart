import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_player/error/song_existed_in_playlist_error.dart';
import 'package:music_player/models/playlist_detail.dart';
import 'package:music_player/error/upload_error.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/services/storage/upload.dart';
import 'references.dart';

Future<void> pushSong(SongDetail songDetail) async {
  Future.wait([
    uploadImage(songDetail.image).then((value) {
      songDetail.imageUrl = value;
    }).catchError((error) {
      print(error.toString());
    }),
    uploadSong(songDetail.song).then((value) {
      songDetail.songUrl = value;
    }).catchError((error) {
      print(error.toString());
    })
  ]).then((value) {
    if (songDetail.imageUrl == null || songDetail.songUrl == null) {
      throw UploadError(message: 'Push song failed');
    } else {
      songItemDetails.add(songDetail.toMap());
    }
  });
}

Future<void> createPlaylist(PlaylistDetail playlistDetail) async {
  await playlistCollection
      .add({'name': playlistDetail.name, 'uid': playlistDetail.uid});
}

Future<void> addSongToPlaylist(
    {String uid, String playlistId, String songId}) async {
  final bool existed = await _songExistedInPlaylist(songId, playlistId);
  if (existed) {
    throw SongExistedInPlaylistError(
        message: 'Song #$songId is already in playlist #$playlistId');
  }
  await songToPlaylist
      .add({'uid': uid, 'playlistId': playlistId, 'songId': songId});
}

Future<void> addOrRemoveLoveSong(String uid, String songId) async {
  if (!(await _documentExist(userData, uid))) {
    print('user is not exists');
    userData.doc(uid).set({'loveSong': []});
  }
  DocumentReference documentReference = userData.doc(uid);
  bool existed = await isLoveSongExist(uid, songId);
  if (!existed) print('not existed');
  return existed
      ? documentReference.update({
          'loveSong': FieldValue.arrayRemove([songId])
        })
      : documentReference.update({
          'loveSong': FieldValue.arrayUnion([songId])
        });
}

Future<bool> isLoveSongExist(String uid, String songId) async {
  if (!await _documentExist(userData, uid)) return false;
  List<String> lovedSongIds = List<String>.from(
      await _extractArrayFieldFromDocumentReference(
          userData.doc(uid), 'loveSong'));
  print(lovedSongIds);
  return lovedSongIds.contains(songId);
}

Future<void> increaseListenTime(String songId) async {
  return await songItemDetails
      .doc(songId)
      .update({'listenTime': FieldValue.increment(1)});
}

Future<List<dynamic>> _extractArrayFieldFromDocumentReference(
    DocumentReference documentReference, String field) async {
  return (await documentReference.get()).data()[field] ?? [];
}

Future<bool> _documentExist(CollectionReference ref, String id) async {
  try {
    DocumentSnapshot documentSnapshot = await ref.doc(id).get();
    return documentSnapshot.exists;
  } catch (e) {
    return false;
  }
}

Future<bool> isInLoveList(String uid, String songId) async {
  final DocumentSnapshot ref = await userData.doc(uid).get();
  return ref.data()['loveSong'].contain(songId);
}

Future<bool> _songExistedInPlaylist(String songId, String playlistId) async {
  final QuerySnapshot querySnapshot = await songToPlaylist
      .where('playlistId', isEqualTo: playlistId)
      .where('songId', isEqualTo: songId)
      .get();
  final List<QueryDocumentSnapshot> snapshot = querySnapshot.docs;
  return (snapshot.length != 0);
}

Future<void> deletePlaylist(String playlistId) async {
  songToPlaylist
      .where('playlistId', isEqualTo: playlistId)
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((QueryDocumentSnapshot snapshot) {
      songToPlaylist.doc(snapshot.id).delete();
    });
  });
  playlistCollection.doc(playlistId).delete();
}
