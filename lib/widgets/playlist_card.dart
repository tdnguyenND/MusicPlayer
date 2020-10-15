import 'package:flutter/material.dart';



class PlaylistCard extends StatefulWidget {
  @override
  _PlaylistCardState createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 130.0,
            width: 130.0,
            child: Image.asset('assets/img1.jpg',
              fit: BoxFit.cover,
            ),

          ),
          Padding(padding: EdgeInsets.all(5.0)),
          Text('Bai hat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.0,
            ),
          )
        ],
      ),
    );
  }
}
