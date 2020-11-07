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
              return Text('Something went wrong!');
            }
            if (snapshot.hasData) {
              List<PlaylistDetail> listOfPlaylist = snapshot.data;
              return Scaffold(
                backgroundColor: Colors.grey[900],
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
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 30, 10, 0),
                      child: Column(
                          children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Nhạc',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(user.photoURL),
                                      radius: 18,
                                    )
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text(
                                      'Playlist',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Card(
                                  color: Colors.grey[900],
                                  borderOnForeground: false,
                                  child: InkWell(
                                    onTap: () {
                                      _createPlaylistWithName();
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Image.asset(
                                            'assets/add_playlist.png',
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          'Tạo playlist',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 20,
                                              letterSpacing: 0.6),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ] +
                              listOfPlaylist.map((PlaylistDetail playlist) {
                                return Card(
                                  color: Colors.grey[900],
                                  borderOnForeground: false,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlaylistWidget(
                                                      playlistDetail:
                                                          playlist)));
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Image.asset(
                                            'assets/img1.jpg',
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Container(
                                          width: 230,
                                          child: Text(
                                            playlist.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 20,
                                                letterSpacing: 0.6),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            _confirmDeletePlaylist(
                                                context, playlist);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList()),
                    )),
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
        contentPadding: const EdgeInsets.all(10.0),
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
                  style: TextStyle(fontSize: 17),
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
// Container(
//   child:ListView.builder(
//     itemCount: listOfPlaylist.length,
//     shrinkWrap: true,
//     itemBuilder: (BuildContext context,int index){
//       return Card(
//         color: Colors.grey[900],
//         borderOnForeground: false,
//         child: InkWell(
//           onTap: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => PlaylistWidget(
//                         playlistDetail: listOfPlaylist[index])));
//           },
//           child: Row(
//             children: [
//               Container(
//                 child: Image.asset('assets/img1.jpg',height: 70,width: 70,
//                   fit: BoxFit.cover,),
//               ),
//               SizedBox(width: 25,),
//               Container(
//                 width: 230,
//                 child: Text(listOfPlaylist[index].name,
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       fontSize: 20,
//                       letterSpacing: 0.6
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.delete,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   _confirmDeletePlaylist(context, listOfPlaylist[index]);
//                 },
//               )
//             ],
//           ),
//         ),
//       );
//     }
//       ))
