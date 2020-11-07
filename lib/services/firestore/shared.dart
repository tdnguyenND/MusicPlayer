import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

const String userDataCollectionName = 'user data';
const String songCollectionName = 'songItemDetails';
const String playlistCollectionName = 'playlistCollection';
const String rapidApiKeyCollectionName = 'rapid api key';

const int chartLimit = 5;

Future<void> matchReferenceKey<T>(Map<String, dynamic> data, String key,
    Future<T> Function(String) mapFunction) async {
  if (data.containsKey(key)) {
    if (data[key] is List) {
      List<T> res = [];
      for (String value in data[key]) {
        res.add(await mapFunction(value));
      }
      data[key] = res;
    } else
      data[key] = await mapFunction(data[key]);
  }
}
