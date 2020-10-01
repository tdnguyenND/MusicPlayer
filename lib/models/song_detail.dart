import 'dart:io';

class SongDetail {
  final String name;
  final String artist;
  final String album;

  final File song;
  final File image;

  String songUrl;
  String imageUrl;

  SongDetail(
      {this.name,
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
}
