import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:media_metadata_plugin/media_media_data.dart';
import 'package:music_player/error/upload_error.dart';
import 'package:music_player/models/song_detail.dart';
import 'package:music_player/services/firestore/song_collection.dart';
import 'package:music_player/services/storage/upload.dart';
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

  String selectedImage;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _songNameController = TextEditingController();
  TextEditingController _artistNameController = TextEditingController();
  TextEditingController _albumNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Colors.white),
                  ],
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF1DB954))),
                  child: InkWell(
                    onTap: selectImage,
                    child: Center(
                      child: _image == null
                          ? Text('Select Image')
                          : Image.file(_image),
                    ),
                  ),
                ),
                FlatButton(
                  color: Color(0xFF1DB954),
                  child: Text(
                    'Select Song',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onPressed: selectSong,
                ),
                TextFormField(
                  controller: _songNameController,
                  validator: (val) =>
                      val == null ? "Song name is required" : null,
                  decoration: InputDecoration(
                    hintText: 'Enter name',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onChanged: (value) {
                    _name = value;
                  },
                ),
                TextFormField(
                  controller: _albumNameController,
                  validator: (val) =>
                      val == null ? "Album name is required" : null,
                  decoration: InputDecoration(
                    hintText: 'Enter album name',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onChanged: (value) {
                    _album = value;
                  },
                ),
                TextFormField(
                  controller: _artistNameController,
                  validator: (val) =>
                      val == null ? "Artist name is required" : null,
                  decoration: InputDecoration(
                    hintText: 'Enter artist name',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onChanged: (value) {
                    _artist = value;
                  },
                ),
                RaisedButton(
                  color: Color(0xFF1DB954),
                  child: Text(
                    'Upload',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
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
                        uploadSong(songDetail);
                      } catch (e) {
                        Fluttertoast.showToast(msg: 'upload failed');
                      }
                    }
                  },
                ),
              ],
            ),
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

    setState(() {});
  }

  void selectSong() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    String path = result.files.single.path;
    _song = File(path);
    AudioMetaData metaData = await MediaMetadataPlugin.getMediaMetaData(path);
    _songNameController.text = _name = basenameWithoutExtension(path);
    _albumNameController.text = _album = metaData.album;
    _artistNameController.text = _artist = metaData.artistName;
  }

  void uploadSong(SongDetail songDetail) async {
    Future.wait([
      uploadImage(songDetail.image).then((value) {
        songDetail.imageUrl = value;
      }).catchError((error) {
        print(error.toString());
      }),
      uploadAudio(songDetail.song).then((value) {
        songDetail.songUrl = value;
      }).catchError((error) {
        print(error.toString());
      })
    ]).then((value) {
      if (songDetail.imageUrl == null || songDetail.songUrl == null) {
        throw UploadError(message: 'Push song failed');
      } else {
        SongFirestore.create(songDetail);
      }
    });
  }
}
