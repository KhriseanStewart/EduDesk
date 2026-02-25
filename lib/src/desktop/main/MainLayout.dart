import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/components/SideNav.dart';
import 'package:mac_app/src/desktop/components/UserCard.dart';
import 'package:mac_app/src/desktop/screens/Dashboard.dart';
import 'package:mac_app/src/desktop/screens/Grades.dart';
import 'package:mac_app/src/desktop/screens/ProgramScreen.dart';
import 'package:mac_app/src/desktop/screens/ScheduleScreen.dart';
import 'package:mac_app/src/desktop/screens/SupportScreen.dart';
import 'package:mac_app/src/desktop/screens/TeacherContentScreen.dart';
import 'package:mac_app/src/utils/responsive.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  static const List<Widget> _screens = [
    Dashboard(),
    ProgramScreen(),
    ScheduleScreen(),
    GradesScreen(),
    SupportScreen(),
    TeacherContentScreen(),
  ];

  static const List<_NavDest> _navItems = [
    _NavDest(icon: Icons.dashboard_rounded, label: 'Dashboard', index: 0),
    _NavDest(icon: Icons.menu_book_rounded, label: 'Courses', index: 1),
    _NavDest(icon: Icons.calendar_today_rounded, label: 'Schedule', index: 2),
    _NavDest(icon: Icons.grade_rounded, label: 'Grades', index: 3),
    _NavDest(icon: Icons.support_agent_rounded, label: 'Support', index: 4),
  ];

  static const List<String> _screenTitles = [
    'Dashboard', 'My Courses', 'Schedule', 'Grades & Transcript', 'Support', 'Teacher Panel',
  ];

  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onNav(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final useMobileShell = context.useMobileShell;

    if (useMobileShell) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            currentIndex < _screenTitles.length ? _screenTitles[currentIndex] : 'EduDesk',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        drawer: _MobileDrawer(
          currentIndex: currentIndex,
          onNav: (index) {
            _onNav(index);
            Navigator.of(context).pop();
          },
        ),
        body: SafeArea(
          child: _screens[currentIndex],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex >= _navItems.length ? 0 : currentIndex,
          onDestinationSelected: (i) => _onNav(_navItems[i].index),
          destinations: _navItems
              .map((d) => NavigationDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.icon, color: const Color(0xFF4DA3B6)),
                    label: d.label,
                  ))
              .toList(),
          height: 64,
          elevation: 8,
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SideNav(
              index: currentIndex,
              onNav: _onNav,
            ),
            Expanded(child: _screens[currentIndex]),
          ],
        ),
      ),
    );
  }
}

class _NavDest {
  final IconData icon;
  final String label;
  final int index;
  const _NavDest({required this.icon, required this.label, required this.index});
}

class _MobileDrawer extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onNav;

  const _MobileDrawer({required this.currentIndex, required this.onNav});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const teacherIndex = 5;

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F2937) : const Color(0xFF4DA3B6).withOpacity(0.1),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4DA3B6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.school_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('EduDesk', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Portal', style: TextStyle(fontSize: 12, color: Color(0xFF538893))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _DrawerTile(icon: Icons.dashboard_rounded, label: 'Dashboard', index: 0, currentIndex: currentIndex, onTap: () => onNav(0)),
                _DrawerTile(icon: Icons.menu_book_rounded, label: 'My Courses', index: 1, currentIndex: currentIndex, onTap: () => onNav(1)),
                _DrawerTile(icon: Icons.calendar_today_rounded, label: 'Schedule', index: 2, currentIndex: currentIndex, onTap: () => onNav(2)),
                _DrawerTile(icon: Icons.grade_rounded, label: 'Grades', index: 3, currentIndex: currentIndex, onTap: () => onNav(3)),
                _DrawerTile(icon: Icons.support_agent_rounded, label: 'Support', index: 4, currentIndex: currentIndex, onTap: () => onNav(4)),
                const Divider(height: 24),
                _DrawerTile(icon: Icons.school_rounded, label: 'Teacher Panel', index: teacherIndex, currentIndex: currentIndex, onTap: () => onNav(teacherIndex)),
              ],
            ),
          ),
          const UserCard2(),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentIndex == index;
    final color = isActive ? const Color(0xFF4DA3B6) : null;

    return ListTile(
      leading: Icon(icon, color: color, size: 24),
      title: Text(label, style: TextStyle(fontWeight: isActive ? FontWeight.w600 : null, color: color)),
      onTap: onTap,
    );
  }
}
