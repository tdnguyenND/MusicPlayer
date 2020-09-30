import 'package:flutter/material.dart';
import 'package:music_player/screens/screen.dart';
void main() {
  runApp(MaterialApp(
      title: 'Music Player',
      routes: {
        '/': (context) => Home(),
      },
    )
  );
}