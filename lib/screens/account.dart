import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/services/auth/auth.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
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
            return Center(
              child: RaisedButton(
                child: Text('Log out'),
                onPressed: logOut,
              ),
            );
          }
        });
  }
}
