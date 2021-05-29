import 'package:music_player/models/serializable.dart';
import 'package:music_player/models/song_detail.dart';

class UserData extends Serializable {
  String id;
  List<SongDetail> loveSong;

  UserData({this.id, this.loveSong});

  static UserData fromMap(Map<String, dynamic> map) {
    return UserData(id: map['id'], loveSong: map['loveSong']);
  }
  
  static UserData fromMapWithouId(Map<String, dynamic> map){
    return UserData(loveSong: map['loveSong']);
  }

  @override
  Map<String, dynamic> serializer() {
    return {
      'id': id,
      'loveSong': loveSong == null ? [] : loveSong.map((item) => item.id).toList()
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'loveSong': loveSong};
  }
}
