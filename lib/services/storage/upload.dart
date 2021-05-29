import 'dart:io';
import 'package:path/path.dart';

import 'package:music_player/shared/const.dart';
import 'package:music_player/error/upload_error.dart';

import 'package:firebase_storage/firebase_storage.dart';

final StorageReference _storageReference = FirebaseStorage.instance.ref();

Future<String> uploadImage(File image) async {
  return await uploadFileToDirectory(image, imgDir);
}

Future<String> uploadAudio(File audio) async {
  return await uploadFileToDirectory(audio, songDir);
}

Future<String> uploadFileToDirectory(File file, String dir) async {
  List<int> fileBytes = file.readAsBytesSync();
  String path = '$dir/${basename(file.path)}';

  try {
    StorageReference ref = _storageReference.child(path);
    StorageUploadTask task = ref.putData(fileBytes);

    String donwloadUrl = await (await task.onComplete).ref.getDownloadURL();

    return donwloadUrl;
  } catch (e) {
    throw UploadError(message: 'Upload file ${file.path} failed');
  }
}
