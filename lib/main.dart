import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_player/services/firestore/push_data.dart';
import 'package:provider/provider.dart';

import 'screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AssetsAudioPlayer player;
    player = AssetsAudioPlayer();
    player.current.listen((event) {
      if (event == null) return;
      Audio audio = event.audio.audio;
      String songId = audio.metas.id;
      increaseListenTime(songId);
    });
  runApp(Provider.value(
    value: player,
    child: MaterialApp(
      title: 'Music Player',
      routes: {
        '/': (context) => Wrapper(),
      },
    ),
  ));
}
