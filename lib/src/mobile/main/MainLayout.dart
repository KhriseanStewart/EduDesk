import 'package:flutter/material.dart';
import 'package:mac_app/src/mobile/screens/Courses.dart';
import 'package:mac_app/src/mobile/screens/Dashboard.dart';
import 'package:mac_app/src/mobile/screens/Grades.dart';
import 'package:mac_app/src/mobile/screens/Profile.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  final List<Widget> _screens = const [
    Dashboard(),
    CourseScreen(),
    GradesScreen(),
    ProfileScreen(),
  ];

  int currentIndex = 0;

  void _onTap(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4DA3B6),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: "Courses",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade_rounded),
            label: "Grades",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
