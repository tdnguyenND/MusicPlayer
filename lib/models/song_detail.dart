import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';

class SongDetail {
  String id;

  final String name;
  final String artist;
  final String album;

  final File song;
  final File image;

  String songUrl;
  String imageUrl;

  Audio _audio;

  SongDetail(
      {this.id,
      this.name,
      this.artist,
      this.album,
      this.song,
      this.image,
      this.songUrl,
      this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'artist': artist,
      'album': album,
      'songUrl': songUrl,
      'imageUrl': imageUrl
    };
  }

  Audio toAudio() {
    _audio = _audio != null
        ? _audio
        : Audio.network(songUrl,
            metas: Metas(
              image: MetasImage.network(imageUrl),
              title: name,
              artist: artist,
              album: album,
            ));
    return this._audio;
  }

  static fromMapWithoutId(Map map) {
    return SongDetail(
        name: map['name'],
        artist: map['artist'],
        album: map['album'],
        songUrl: map['songUrl'],
        imageUrl: map['imageUrl']);
  }

  static fromMap(Map map) {
    return SongDetail(
        id: map['id'],
        name: map['name'],
        artist: map['artist'],
        album: map['album'],
        songUrl: map['songUrl'],
        imageUrl: map['imageUrl']);
  }
}
