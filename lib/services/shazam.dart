import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

enum ShazamServiceStatus {
  INITIALIZING,
  READY,
  DETECTING,
  DETECTING_TIMEOUT,
  SONG_FOUND
}

class ShazamService {
  String path;

  String apiPath = 'https://shazam.p.rapidapi.com/songs/detect';
  String apiToken = '45d82d4d46mshb4b85c3cdb18340p1062edjsn012c79b3b39e';
  Duration timeout = Duration(seconds: 9);
  Duration detectingDelay = Duration(seconds: 2, microseconds: 500);

  String result;

  String fileName = '/record.raw';

  String filePath;
  FlutterSoundRecorder recorder;

  ShazamServiceStatus status;

  Stream<ShazamServiceStatus> onStatusChanged;
  StreamController<ShazamServiceStatus> onStatusChangedController;

  ShazamService() {
    status = ShazamServiceStatus.INITIALIZING;
    onStatusChangedController = StreamController<ShazamServiceStatus>();
    onStatusChanged = onStatusChangedController.stream;
    recorder = FlutterSoundRecorder();
    recorder.openAudioSession();
    _init();
  }

  void setStatus(ShazamServiceStatus newStatus) {
    status = newStatus;
    onStatusChangedController.add(status);
  }

  void _init() async {
    path = (await getApplicationDocumentsDirectory()).path;
    filePath = path + fileName;
    setStatus(ShazamServiceStatus.READY);
  }

  Future<String> startDetecting() async {
    result = null;
    File(filePath).delete();
    await recorder.startRecorder(
        codec: Codec.pcm16,
        toFile: filePath,
        numChannels: 1,
        sampleRate: 44100);
    setStatus(ShazamServiceStatus.DETECTING);
    setDetectInterval();
    setDetectingTimeout();

    while (status == ShazamServiceStatus.DETECTING) {
      await Future.delayed(const Duration(milliseconds: 100), () {});
    }
    setStatus(ShazamServiceStatus.READY);
    return result;
  }

  void stopDetecting() async {
    await recorder.stopRecorder();
    File(filePath).delete();
    setStatus(ShazamServiceStatus.READY);
  }

  void setDetectingTimeout() {
    Timer(timeout, () {
      if (status == ShazamServiceStatus.DETECTING) {
        setStatus(ShazamServiceStatus.DETECTING_TIMEOUT);
        print('time out');
      }
    });
  }

  void setDetectInterval() {
    int counter = 1;
    Timer.periodic(detectingDelay, (t) async {
      print('try $counter time(s)');
      counter++;
      if (status != ShazamServiceStatus.DETECTING) {
        t.cancel();
        recorder.stopRecorder();
      } else {
        File file = File(filePath);
        print(await file.length());
        result = await detect(file.readAsBytesSync());
        if (status == ShazamServiceStatus.DETECTING && result != null) {
          file.delete();
          setStatus(ShazamServiceStatus.SONG_FOUND);
          recorder.stopRecorder();
          t.cancel();
        }
      }
    });
  }

  Future<String> detect(Uint8List data) async {
    String base64 = Base64Encoder().convert(data);
    Response response = await post(apiPath,
        headers: {
          'x-rapidapi-host': "shazam.p.rapidapi.com",
          'x-rapidapi-key': apiToken,
          'content-type': "text/plain",
        },
        body: base64);
    print(response.body);
    var objectResponse = json.decode(response.body);
    if (objectResponse['track'] != null) {
      return objectResponse['track']['title'].toString();
    } else {
      return null;
    }
  }
}
