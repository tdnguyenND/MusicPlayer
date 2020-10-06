import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/services/firestore/fetch_data.dart';

class PlaylistDetail {
  String id;
  String uid;
  String name;
  List<SongDetail> songDetails;

  PlaylistDetail({this.id, this.uid, this.name});

  Future<List<Audio>> get playlist async {
    return songDetails.map((detail) => detail.toAudio()).toList();
  }

  void addSong(SongDetail songDetail) {
    songDetail = songDetail ?? [];
    this.songDetails.add(songDetail);
  }

  Future<void> fetchSongs() async {
    if (id != null) {
      songDetails = await getSongOfPlaylist(id);
    } else
      songDetails = await getAllSongOrderByName();
  }
}
