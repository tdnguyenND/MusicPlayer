import 'package:music_player/models/serializable.dart';

class RapidApiKey extends Serializable {
  String id;
  String value;
  int counter;

  RapidApiKey({this.id, this.value, this.counter});

  static RapidApiKey fromMapWithoutId(Map<String, dynamic> map) {
    return RapidApiKey(
        id: map['id'], value: map['value'], counter: map['counter']);
  }

  @override
  Map<String, dynamic> serializer() {
    return {
      'id': id,
      'value': value,
      'counter': counter,
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
      'counter': counter,
    };
  }
}
