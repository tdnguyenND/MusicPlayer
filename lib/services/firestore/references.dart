import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference songItemDetails =
    FirebaseFirestore.instance.collection('songItemDetails');

final CollectionReference playlistCollection =
    FirebaseFirestore.instance.collection('playlistCollection');

final CollectionReference songToPlaylist =
    FirebaseFirestore.instance.collection('songToPlaylist');
