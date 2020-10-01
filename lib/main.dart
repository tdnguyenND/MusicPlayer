import 'package:flutter/material.dart';
import 'package:music_player/screens/screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'Music Player',
    routes: {
      '/': (context) => Home(),
    },
  ));
}
