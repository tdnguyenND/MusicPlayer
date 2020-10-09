
import 'package:flutter/material.dart';
import 'dart:core';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          child: ListView(
              children: <Widget>[
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.fromLTRB(5,0,0,0),
                              child:Column(
                                children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(Icons.settings, color: Colors.white,)
                                      ]
                                  ),
                                  SizedBox(height: 50),
                                  Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Text('Phat gan day',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 23.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          height: 165.0,
                                          child: ListView.builder(
                                            itemCount: 10,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context, int index) {
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
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 25,),
                                        Row(
                                          children: [
                                            Text('Moi phat hanh cho ban',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 23.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          height: 165.0,
                                          child: ListView.builder(
                                            itemCount: 10,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context, int index) {
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
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 25,),
                                        Row(
                                          children: [
                                            Text('Album pho bien',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 23.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          height: 165.0,
                                          child: ListView.builder(
                                            itemCount: 10,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context, int index) {
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
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 25,),
                                        Row(
                                          children: [
                                            Text('Danh cho ban',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 23.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          height: 165.0,
                                          child: ListView.builder(
                                            itemCount: 10,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context, int index) {
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
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 25,),
                                        Row(
                                          children: [
                                            Text('Nghe si pho bien',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 23.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          height: 165.0,
                                          child: ListView.builder(
                                            itemCount: 10,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                child: Column(
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      backgroundImage: AssetImage('assets/img1.jpg'),
                                                      radius: 55,
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
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              )
                          ),
                        ]
                    )
                )
              ]
          )
      ),
    );
  }
}
List<String> imageurl = [
  'assets/img1.jpg',
  'assets/img1.jpg',
  'assets/img1.jpg',
  'assets/img1.jpg',
  'assets/img1.jpg',
  'assets/img1.jpg',
  'assets/img1.jpg',
  'assets/img1.jpg',
];
