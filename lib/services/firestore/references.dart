import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference songItemDetails =
    FirebaseFirestore.instance.collection('songItemDetails');