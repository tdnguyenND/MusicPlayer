import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_player/models/rapid_api_key.dart';

class RapidApiKeyFirestore {
  static final CollectionReference rapidApiKeyRef =
      FirebaseFirestore.instance.collection('rapid api key');

  static Future<RapidApiKey> getRapidApiKey(String id) async {
    DocumentSnapshot snapshot = await rapidApiKeyRef.doc(id).get();
    RapidApiKey res = RapidApiKey.fromMapWithoutId(snapshot.data());
    res.id = id;
    return snapshot.exists ? res : null;
  }

  static Future<RapidApiKey> getAvailableKey() async {
    QuerySnapshot querySnapshot = await rapidApiKeyRef
        .orderBy('counter', descending: true)
        .limit(1)
        .get();
    QueryDocumentSnapshot chosen = querySnapshot.docs.first;
    RapidApiKey res = RapidApiKey.fromMapWithoutId(chosen.data());
    res.id = chosen.id;
    if (res.counter <= 0) throw KeyNotAvailable();
    res.id = chosen.id;
    return res;
  }

  static Future<RapidApiKey> decreaseApiKeyCounter(String id) async {
    await rapidApiKeyRef.doc(id).update({'counter': FieldValue.increment(-1)});
    return getRapidApiKey(id);
  }
}

class KeyNotAvailable extends Error {
  String msg;
  KeyNotAvailable({this.msg = 'Key not availble'});
}
