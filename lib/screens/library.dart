import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_player/models/playlist_detail.dart';
import 'package:music_player/services/firestore/fetch_data.dart';
import 'package:music_player/services/firestore/push_data.dart';
import 'package:music_player/widgets/playlist_widget.dart';
import 'package:provider/provider.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  PlaylistDetail selectedPlaylist;
  User user;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    if (user != null) {
      return MaterialApp(
        home: StreamBuilder(
          stream: userPlaylists(user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text('Something went wrong!');
            }
            if (snapshot.hasData) {
              List<PlaylistDetail> listOfPlaylist = snapshot.data;
              return Center(
                child: Column(
                  children: <Widget>[] +
                      listOfPlaylist.map((PlaylistDetail playlist) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 5),
                          child: FlatButton(
                            color: Colors.grey[200],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(playlist.name),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                  ),
                                  onPressed: () {
                                    _confirmDeletePlaylist(context, playlist);
                                  },
                                )
                              ],
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlaylistWidget(
                                          playlistDetail: playlist)));
                            },
                          ),
                        );
                      }).toList() +
                      [
                        RaisedButton(
                          child: Text('Create playlist'),
                          onPressed: () {
                            _createPlaylistWithName();
                          },
                        )
                      ],
                ),
              );
            } else {
              return SpinKitCircle(
                color: Colors.black,
              );
            }
          },
        ),
      );
    } else {
      return Center(
        child: Column(
          children: [
            Text('Please log in first'),
            Text('Go to Account from the bottom navigation bar')
          ],
        ),
      );
    }
  }

  void _createPlaylistWithName() {
    String _newPlaylistName;
    final _formKey = GlobalKey<FormState>();
    showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  autofocus: true,
                  validator: (value) => value == null
                      ? 'Please enter a name for your playlist'
                      : null,
                  decoration: InputDecoration(
                      labelText: 'Playlist name', hintText: 'eg. My playlist'),
                  onChanged: (value) {
                    _newPlaylistName = value;
                  },
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              }),
          FlatButton(
              child: const Text('OK'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  Navigator.pop(context);
                  PlaylistDetail detail =
                      PlaylistDetail(uid: user.uid, name: _newPlaylistName);
                  await createPlaylist(detail);
                  setState(() {});
                }
              })
        ],
      ),
    );
  }

  void _confirmDeletePlaylist(BuildContext context, PlaylistDetail detail) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Delete play list ${detail.name}'),
        actions: [
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('Delete'),
            onPressed: () {
              deletePlaylist(detail.id);
              Navigator.pop(context);
              setState(() {});
            },
          )
        ],
      ),
    );
  }
}
