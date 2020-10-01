import 'references.dart';
import 'package:music_player/error/upload_error.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/services/storage/upload.dart';

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
