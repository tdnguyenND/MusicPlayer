abstract class Serializable {
  Map<String, dynamic> toMap();
  Map<String, dynamic> toMapWithOutID() {
    Map map = this.toMap();
    if (map.containsKey('id')) map.remove('id');
    return map;
  }

  Map<String, dynamic> serializer();
  Map<String, dynamic> serializerWithoutID() {
    Map map = this.serializer();
    if (map.containsKey('id')) map.remove('id');
    return map;
  }
}
