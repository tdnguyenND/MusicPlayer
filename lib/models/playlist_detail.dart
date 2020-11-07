import 'package:music_player/models/serializable.dart';
import 'package:music_player/models/song_detail.dart';


class PlaylistDetail extends Serializable {
  String id;
  String uid;
  String name;
  List<SongDetail> listSongs;

  PlaylistDetail({this.id, this.uid, this.name, this.listSongs});

  static PlaylistDetail fromMapWithouId(Map<String, dynamic> map) {
    return PlaylistDetail(
        uid: map['uid'], name: map['name'], listSongs: map['listSongs']);
  }

  @override
  Map<String, dynamic> serializer() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'listSongs': listSongs == null ? [] : listSongs.map((item) => item.id).toList(),
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'listSongs': listSongs,
    };
  }
}
