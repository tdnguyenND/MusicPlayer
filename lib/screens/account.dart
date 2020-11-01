import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/playlist_detail.dart';
import 'package:music_player/screens/screen.dart';
import 'package:music_player/services/auth/auth.dart';
import 'package:music_player/widgets/playlist_widget.dart';
import 'package:provider/provider.dart';
import 'package:music_player/services/firestore/fetch_data.dart';
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
                      image: DecorationImage(
                          image: AssetImage('assets/1.jpg'),
                          fit: BoxFit.cover)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 200,
                          child: Center(
                            child: Text(
                              "Hello",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          child: SignInButton(
                            Buttons.FacebookNew,
                            text: "Continue with Facebook",
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
                            text: "Continue with Google",
                            onPressed: signInWithGoogle,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Hip Hop never die',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              User user = snapshot.data;
              String urlAvatar = user.photoURL??'https://cf.shopee.vn/file/e7dd17a0cc48f110a3da8c693e910b15';
              return Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color(0xff191414),
                            Color(0xFF1db954),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topLeft,
                          stops: [0.015, 0.7])),
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
                              backgroundImage: NetworkImage(urlAvatar),

                              radius: 45,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              user.displayName ?? 'display name',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 23),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              user.email ?? 'Not connected to email',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
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
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'Up load song',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Console'),
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
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'Song you liked',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Console'),
                              ),
                              onPressed: () async {
                                PlaylistDetail pd =
                                    await getLovedSongAsPlaylist(user.uid);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlaylistWidget(
                                            playlistDetail: pd)));
                              },
                            ),
                          ),
                          Container(
                            height: 70,
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 10),
                            child: RaisedButton(
                              colorBrightness: Brightness.light,
                              color: Color(0xffd4f8dd).withOpacity(0.45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'Log out',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Console'),
                              ),
                              onPressed: () async {
                                await player.stop();
                                logOut();
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
