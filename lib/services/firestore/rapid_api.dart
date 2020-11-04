import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_player/models/rapid_api_key.dart';

final CollectionReference rapidApiRef =
    FirebaseFirestore.instance.collection('rapid api key');

Future<RapidApiKey> getRapidApiKey() async {
  QuerySnapshot querySnapshot =
      await rapidApiRef.orderBy('counter', descending: true).limit(1).get();
  QueryDocumentSnapshot chosen = querySnapshot.docs.first;
  RapidApiKey res = RapidApiKey.fromMap(chosen.data());
  if (res.counter <= 0) throw KeyNotAvailable();
  res.id = chosen.id;
  return res;
}

Future<void> decreaseApiKeyCounter(String id) {
  print(id);
  return rapidApiRef.doc(id).update({'counter': FieldValue.increment(-1)});
}

class KeyNotAvailable extends Error {
  String msg;
  KeyNotAvailable({this.msg = 'Key not availble'});
}
