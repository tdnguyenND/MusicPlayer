import 'package:flutter/material.dart';
import 'dart:core';


class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  List<String>img = ['assets/genre.png','assets/genre.png','assets/genre.png','assets/genre.png','assets/genre.png','assets/genre.png',
    'assets/genre.png','assets/genre.png','assets/genre.png','assets/genre.png','assets/genre.png'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
          // color: Colors.black.withOpacity(0.78),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.tealAccent[200],
                  Colors.lightGreenAccent[200],
                  Colors.grey[850],
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topRight,
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              SizedBox(height: 70,),
              Text('Tìm kiếm',
                style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5
                ),),
              SizedBox(height: 20,),
              Card(
                color: Colors.white.withOpacity(0.95),
                child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Nghệ sĩ, bài hát, hoặc podcast",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                        letterSpacing: 0.5
                    )
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text('Duyệt tìm tất cả',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),),
                ],
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (170 / 100),
                  children: List.generate(img.length, (index) {
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        child: Image.asset(img[index],
                            fit: BoxFit.cover),
                      ),
                    );
                  }),
                ),
              )
            ],
          ),

        )
    );
  }
}