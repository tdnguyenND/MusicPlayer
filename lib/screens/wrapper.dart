import 'package:flutter/material.dart';
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
      'name': 'upload',
      'widget': UploadScreen(),
      'icon': Icon(Icons.cloud_upload)
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: screens[status]['widget']),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}
