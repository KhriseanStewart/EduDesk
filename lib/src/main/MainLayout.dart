import 'package:flutter/material.dart';
import 'package:mac_app/src/components/Header.dart';
import 'package:mac_app/src/components/SideNav.dart';
import 'package:mac_app/src/screens/Dashboard.dart';
import 'package:mac_app/src/screens/ProgramScreen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final List<Widget> _screen = [
    Dashboard(),
    ProgramScreen(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SideNav(
              index: currentIndex,
              onNav: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            Expanded(child: _screen[currentIndex]),
          ],
        ),
      ),
    );
  }
}
