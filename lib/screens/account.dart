import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/playlist_detail.dart';
import 'package:music_player/screens/screen.dart';
import 'package:music_player/services/auth/auth.dart';
import 'package:music_player/services/firestore/user_data_collection.dart';
import 'package:music_player/widgets/playlist_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

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
              return Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [
                        0.1,
                        0.4,
                        0.6,
                        0.9
                      ],
                          colors: [
                        Colors.yellow,
                        Colors.red,
                        Colors.indigo,
                        Colors.teal
                      ])),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 200,
                          child: Center(
                            child: Text(
                              "Continue with",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          child: SignInButton(
                            Buttons.FacebookNew,
                            text: "Facebook",
                            onPressed: signInWithFacebook,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          child: SignInButton(
                            Buttons.Google,
                            text: "Google",
                            onPressed: signInWithGoogle,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              User user = snapshot.data;
              return Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(user.photoURL),
                              radius: 45,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              user.displayName ?? 'display name',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              user.email ?? 'Not connected to email',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: Color(0xFF1DB954)),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                child: Text(
                                  'Log out',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () async {
                                  await player.stop();
                                  logOut();
                                },
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: 400,
                              child: Divider(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 300,
                        child: ListView(shrinkWrap: true, children: [
                          Container(
                            height: 70,
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 10),
                            child: RaisedButton(
                              color: Color(0xffd4f8dd).withOpacity(0.45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Upload song',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UploadScreen()));
                              },
                            ),
                          ),
                          Container(
                            height: 70,
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 10),
                            child: RaisedButton(
                              color: Color(0xffd4f8dd).withOpacity(0.45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Song you liked',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () async {
                                PlaylistDetail pd = await UserDataFirestore
                                    .getLoveSongsAsPlaylist(user.uid);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlaylistWidget(
                                            playlistDetail: pd)));
                              },
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
