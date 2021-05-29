import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_player/models/serializable.dart';

class SongDetail extends Serializable {
  String id;

  final String name;
  final String artist;
  final String album;

  final File song;
  final File image;

  String songUrl;
  String imageUrl;

  Timestamp created;

  int listenTime;

  Audio _audio;

  SongDetail(
      {this.id,
      this.name,
      this.artist,
      this.album,
      this.song,
      this.image,
      this.songUrl,
      this.imageUrl,
      this.created,
      this.listenTime = 0}) {
    this.created = this.created ?? Timestamp.now();
  }

  Audio toAudio() {
    _audio = _audio != null
        ? _audio
        : Audio.network(songUrl,
            metas: Metas(
                id: id,
                image: MetasImage.network(imageUrl),
                title: name,
                artist: artist,
                album: album,
                extra: {'detail': this}));
    return this._audio;
  }

  static fromMapWithoutId(Map map) {
    return SongDetail(
        name: map['name'],
        artist: map['artist'],
        album: map['album'],
        songUrl: map['songUrl'],
        imageUrl: map['imageUrl'],
        created: map['created'] ?? Timestamp.now(),
        listenTime: map['listenTime'] ?? 0);
  }

  static fromMap(Map map) {
    return SongDetail(
        id: map['id'],
        name: map['name'],
        artist: map['artist'],
        album: map['album'],
        songUrl: map['songUrl'],
        imageUrl: map['imageUrl'],
        created: map['created'] ?? Timestamp.now(),
        listenTime: map['listenTime'] ?? 0);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'artist': artist,
      'album': album,
      'songUrl': songUrl,
      'imageUrl': imageUrl,
      'created': created,
      'listenTime': listenTime
    };
  }

  @override
  Map<String, dynamic> serializer(){
    return {
      'id': id,
      'name': name,
      'artist': artist,
      'album': album,
      'songUrl': songUrl,
      'imageUrl': imageUrl,
      'created': created,
      'listenTime': listenTime
    };
  }
}
