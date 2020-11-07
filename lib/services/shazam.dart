import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:music_player/models/rapid_api_key.dart';
import 'package:music_player/services/firestore/rapid_api.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

enum ShazamServiceStatus {
  INITIALIZING,
  READY,
  DETECTING,
  DETECTING_TIMEOUT,
  SONG_FOUND,
  UNAVAILABLE,
}

class ShazamService {
  String path;

  String apiPath = 'https://shazam.p.rapidapi.com/songs/detect';
  RapidApiKey apiToken;
  Duration timeout = Duration(seconds: 9);
  Duration detectingDelay = Duration(seconds: 2, microseconds: 500);

  Map result;

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
    await obtainToken();
  }

  Future<void> obtainToken() async {
    try {
      apiToken = await RapidApiKeyFirestore.getAvailableKey();
      setStatus(ShazamServiceStatus.READY);
    } catch (Error) {
      setStatus(ShazamServiceStatus.UNAVAILABLE);
    }
  }

  Future<Map> startDetecting() async {
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
    Timer.periodic(detectingDelay, (t) async {
      if (status != ShazamServiceStatus.DETECTING) {
        t.cancel();
        recorder.stopRecorder();
      } else {
        File file = File(filePath);
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

  Future<Map> detect(Uint8List data) async {
    if (apiToken.counter <= 0) {
      await obtainToken();
    }
    if (status == ShazamServiceStatus.UNAVAILABLE) return null;
    String base64 = Base64Encoder().convert(data);
    Response response = await post(apiPath,
        headers: {
          'x-rapidapi-host': "shazam.p.rapidapi.com",
          'x-rapidapi-key': apiToken.value,
          'content-type': "text/plain",
        },
        body: base64);
    apiToken = await RapidApiKeyFirestore.decreaseApiKeyCounter(apiToken.id);
    var objectResponse = json.decode(response.body);
    if (objectResponse['track'] != null) {
      return {
        'title': objectResponse['track']['title'].toString(),
        'subtitle': objectResponse['track']['subtitle'].toString(),
      };
    } else {
      return null;
    }
  }
}
