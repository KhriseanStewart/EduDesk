// lib/src/main/MainLayout.dart - UPDATED

import 'package:flutter/material.dart';
import 'package:mac_app/src/components/SideNav.dart';
import 'package:mac_app/src/screens/Dashboard.dart';
import 'package:mac_app/src/screens/Grades.dart';
import 'package:mac_app/src/screens/ProgramScreen.dart';
import 'package:mac_app/src/screens/ScheduleScreen.dart';
import 'package:mac_app/src/screens/SupportScreen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final List<Widget> _screens = const [
    Dashboard(),
    ProgramScreen(),
    ScheduleScreen(),
    GradesScreen(),
    SupportScreen(),
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
            Expanded(child: _screens[currentIndex]),
          ],
        ),
      ),
    );
  }
}