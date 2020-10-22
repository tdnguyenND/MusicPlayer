import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:media_metadata_plugin/media_media_data.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/services/firestore/push_data.dart';
import 'package:path/path.dart';
import 'package:media_metadata_plugin/media_metadata_plugin.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File _image;
  File _song;
  String _name;
  String _artist;
  String _album;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _songNameController = TextEditingController();
  TextEditingController _artistNameController = TextEditingController();
  TextEditingController _albumNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('upload song'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              FlatButton(
                color: Colors.grey,
                child: Text('Select Image'),
                onPressed: selectImage,
              ),
              FlatButton(
                color: Colors.grey,
                child: Text('Select Song'),
                onPressed: selectSong,
              ),
              TextFormField(
                controller: _songNameController,
                validator: (val) =>
                    val == null ? "Song name is required" : null,
                decoration: InputDecoration(hintText: 'Enter name'),
                onChanged: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                controller: _albumNameController,
                validator: (val) =>
                    val == null ? "Album name is required" : null,
                decoration: InputDecoration(hintText: 'Enter album name'),
                onChanged: (value) {
                  _album = value;
                },
              ),
              TextFormField(
                controller: _artistNameController,
                validator: (val) =>
                    val == null ? "Artist name is required" : null,
                decoration: InputDecoration(hintText: 'Enter artist name'),
                onChanged: (value) {
                  _artist = value;
                },
              ),
              RaisedButton(
                child: Text('upload'),
                onPressed: () {
                  if (_formKey.currentState.validate() &&
                      _song != null &&
                      _image != null) {
                    SongDetail songDetail = SongDetail(
                        album: _album,
                        artist: _artist,
                        song: _song,
                        image: _image,
                        name: _name);
                    try {
                      pushSong(songDetail);
                    } catch (e) {
                      Fluttertoast.showToast(msg: 'upload failed');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      )),
    );
  }

  void selectImage() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      _image = File(result.files.single.path);
    }
  }

  void selectSong() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    String path = result.files.single.path;
    _song = File(path);
    AudioMetaData metaData = await MediaMetadataPlugin.getMediaMetaData(path);
    _songNameController.text = _name = basenameWithoutExtension(path);
    _albumNameController.text = metaData.album;
    _artistNameController.text = metaData.artistName;
  }
}
