// lib/src/main/MainLayout.dart - UPDATED

import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/components/SideNav.dart';
import 'package:mac_app/src/desktop/screens/Dashboard.dart';
import 'package:mac_app/src/desktop/screens/Grades.dart';
import 'package:mac_app/src/desktop/screens/ProgramScreen.dart';
import 'package:mac_app/src/desktop/screens/ScheduleScreen.dart';
import 'package:mac_app/src/desktop/screens/SupportScreen.dart';
import 'package:mac_app/src/desktop/screens/TeacherDashboard.dart';

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
    Teacherdashboard(),
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
