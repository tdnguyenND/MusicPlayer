import 'package:flutter/material.dart';
import 'package:music_player/screens/bottom_playing_bar.dart';
import 'package:music_player/services/auth/auth.dart';
import 'package:provider/provider.dart';
import 'screen.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int status = 0;

  List<Map> screens = [
    {'name': 'Home', 'widget': Home(), 'icon': Icon(Icons.home)},
    {'name': 'Search', 'widget': Search(), 'icon': Icon(Icons.search)},
    {'name': 'Library', 'widget': Library(), 'icon': Icon(Icons.library_music)},
    {'name': 'Account', 'widget': Account(), 'icon': Icon(Icons.account_circle)}
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: auth.authStateChanges(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: SafeArea(child: screens[status]['widget']),
            ),
            BottomPlayingBar(
              
            ),
            Container()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: status,
          //backgroundColor: Colors.black54.withOpacity(0.7),
          backgroundColor: Color(0xFF282828),
          unselectedItemColor: Color(0xFFC4C4C4),
          selectedItemColor: Colors.white,
          items: screens
              .map((scr) => BottomNavigationBarItem(
                  title: Text(scr['name']), icon: scr['icon'],backgroundColor: Colors.white))
              .toList(),
          onTap: (value) {
            setState(() {
              status = value;
            });
          },
        ),
      ),
    );
  }
}
