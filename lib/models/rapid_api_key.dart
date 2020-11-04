class RapidApiKey {
  String id;
  String value;
  int counter;

  RapidApiKey({this.id, this.value, this.counter});

  static RapidApiKey fromMap(Map<String, dynamic> map) {
    return RapidApiKey(
        id: map['id'], value: map['value'], counter: map['counter']);
  }
}
