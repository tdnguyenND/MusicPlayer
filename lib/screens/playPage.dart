import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var textColor = Color.fromRGBO(250, 250, 250, 0.95);
    var textStyle = TextStyle(fontFamily: 'PT Sans', color: textColor);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: <Color>[
              Color.fromRGBO(30, 150, 50, 1),
              Color.fromRGBO(40, 158, 59, 1),
              Color.fromRGBO(76, 138, 86, 1),
              Color.fromRGBO(84, 142, 93, 1),
              Color.fromRGBO(88, 106, 91, 1),
              Color.fromRGBO(59, 66, 60, 1),
              Color.fromRGBO(47, 52, 48, 1),
              Color.fromRGBO(34, 40, 35, 1),
              Color.fromRGBO(31, 31, 31, 1),
              Color.fromRGBO(30, 31, 32, 1),
              Color.fromRGBO(28, 28, 28, 1),
              Color.fromRGBO(25, 25, 25, 1),
              Color.fromRGBO(20, 20, 20, 1),
              Color.fromRGBO(18, 18, 18, 1),
              Color.fromRGBO(17, 17, 17, 1),
              Color.fromRGBO(15, 15, 15, 1),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.keyboard_arrow_down,
                    color: Colors.white54, size: 24),
                Text(
                  'Imagine Dragons',
                  style: textStyle.merge(TextStyle(fontSize: 15)),
                ),
                Icon(Icons.more_vert, color: Colors.white54, size: 24),
              ],
            ),
            SizedBox(height: 40),
            SizedBox(width: 320, child: Image.asset('images/img1.jpg')),
            SizedBox(height: 30),
            Text('Radioactive'.toUpperCase(),
                style: textStyle.merge(TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1))),
            SizedBox(height: 5),
            Text('Imagine Dragons',
                style: textStyle
                    .merge(TextStyle(fontSize: 18, color: Colors.white54))),
            SizedBox(height: 24),
            Row(
              children: <Widget>[
                Container(
                  width: 144,
                  height: 1.5,
                  color: Colors.white54,
                ),
                Flexible(
                  child: Container(
                    height: 1.0,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '1;27',
                  style: textStyle.merge(TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(250, 250, 250, 0.46))),
                ),
                Text(
                  '2:16',
                  style: textStyle.merge(TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(250, 250, 250, 0.46))),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  Icons.favorite_border,
                  color: Colors.white54,
                ),
                Icon(
                  Icons.skip_previous,
                  color: Colors.white54,
                  size: 50,
                ),
                Icon(
                  Icons.play_circle_filled,
                  color: textColor,
                  size: 70,
                ),
                Icon(
                  Icons.skip_next,
                  color: textColor,
                  size: 50,
                ),
                Icon(
                  Icons.remove_circle_outline_outlined,
                  color: Colors.white54,
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.devices, color: Colors.green, size: 18),
                Icon(Icons.share, color: Colors.white54, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
