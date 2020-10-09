import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/playlist_detail.dart';
import 'package:music_player/screens/screen.dart';
import 'package:music_player/services/auth/auth.dart';
import 'package:music_player/widgets/playlist_widget.dart';
import 'package:provider/provider.dart';
import 'package:music_player/services/firestore/fetch_data.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    final AssetsAudioPlayer player = Provider.of<AssetsAudioPlayer>(context);
    return MaterialApp(
      home: StreamBuilder<User>(
          stream: userStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong!'),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  children: [
                    RaisedButton(
                      child: Text('Sign in with Facebook'),
                      onPressed: signInWithFacebook,
                    ),
                    RaisedButton(
                      child: Text('Sign in with Google'),
                      onPressed: signInWithGoogle,
                    )
                  ],
                ),
              );
            } else {
              User user = snapshot.data;
              return ListView(children: [
                FlatButton(
                  color: Colors.grey[200],
                  child: Text('Up load song'),
                  onPressed: () {
                    Navigator.push(context, 
                      MaterialPageRoute(
                        builder: (context) => UploadScreen()
                      )
                    );
                  },
                ),
                FlatButton(
                  color: Colors.grey[200],
                  child: Text('Song you liked'),
                  onPressed: () async {
                    PlaylistDetail pd = await getLovedSongAsPlaylist(user.uid);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PlaylistWidget(playlistDetail: pd)));
                  },
                ),
                FlatButton(
                  color: Colors.grey[200],
                  child: Text('Log out'),
                  onPressed: () async {
                    await player.stop();
                    logOut();
                  },
                ),
              ]);
            }
          }),
    );
  }
}
