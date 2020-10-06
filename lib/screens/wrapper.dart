import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
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
    {'name': 'home', 'widget': Home(), 'icon': Icon(Icons.home)},
    {
      'name': 'search',
      'widget': Search(),
      'icon': Icon(Icons.search)
    },
    {
      'name': 'library',
      'widget': Library(),
      'icon': Icon(Icons.library_music)
    },
    {
      'name': 'upload',
      'widget': UploadScreen(),
      'icon': Icon(Icons.cloud_upload)
    },
    {
      'name': 'account',
      'widget': Account(),
      'icon': Icon(Icons.account_circle)
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AssetsAudioPlayer(),
      child: StreamProvider.value(
        value: auth.authStateChanges(),
        child: Scaffold(
          body: SafeArea(child: screens[status]['widget']),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: status,
            items: screens
                .map((scr) => BottomNavigationBarItem(
                    title: Text(scr['name']), icon: scr['icon']))
                .toList(),
            onTap: (value) {
              setState(() {
                status = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
