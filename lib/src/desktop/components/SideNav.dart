import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/LMS%20models/lms_models.dart';
import 'package:mac_app/src/desktop/components/UserCard.dart';

class SideNav extends StatelessWidget {
  final Function(int) onNav;
  final int index;

  const SideNav({super.key, required this.index, required this.onNav});

  @override
  Widget build(BuildContext context) {
    final User user = User(
      role: "teacher",
      id: "1",
      name: "Khrisean Prinz",
      studentId: "111-111-111",
      email: "stewartkhrisean8@gmail.com",
      avatarUrl: "",
      program: "",
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return size.width > 760
        ? Container(
            width: 288,
            height: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : Colors.white,
              border: Border(
                right: BorderSide(
                  color: isDark
                      ? const Color(0xFF1F2937)
                      : const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.school,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'EduDesk',
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF0F181A),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'DESK PORTAL',
                                  style: TextStyle(
                                    color: Color(0xFF538893),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // Navigation Items
                      _NavItem(
                        icon: Icons.dashboard,
                        label: 'Dashboard',
                        isActive: index == 0,
                        isDark: isDark,
                        onTap: () => onNav(0),
                      ),
                      const SizedBox(height: 8),
                      _NavItem(
                        icon: Icons.book,
                        label: 'My Courses',
                        isActive: index == 1,
                        isDark: isDark,
                        onTap: () => onNav(1),
                      ),
                      const SizedBox(height: 8),
                      _NavItem(
                        icon: Icons.calendar_today,
                        label: 'Schedule',
                        isActive: index == 2,
                        isDark: isDark,
                        onTap: () => onNav(2),
                      ),
                      const SizedBox(height: 8),
                      _NavItem(
                        icon: Icons.grade,
                        label: 'Grades',
                        isActive: index == 3,
                        isDark: isDark,
                        onTap: () => onNav(3),
                      ),
                      const SizedBox(height: 8),
                      _NavItem(
                        icon: Icons.support_agent,
                        label: 'Support',
                        isActive: index == 4,
                        isDark: isDark,
                        onTap: () => onNav(4),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (user.role == "teacher")
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: _NavItem(
                      icon: Icons.add_moderator_outlined,
                      isActive: index == 5,
                      isDark: isDark,
                      onTap: () => onNav(5),
                      label: "Teacher Panel",
                    ),
                  ),
                // User Profile Section
                UserCard2(),
              ],
            ),
          )
        : Container(
            width: 128,
            height: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : Colors.white,
              border: Border(
                right: BorderSide(
                  color: isDark
                      ? const Color(0xFF1F2937)
                      : const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.school,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'EduDesk',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F181A),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 40),
                      // Navigation Items
                      _NavItem(
                        icon: Icons.dashboard,
                        isActive: index == 0,
                        isDark: isDark,
                        onTap: () => onNav(0),
                      ),
                      const SizedBox(height: 8),
                      _NavItem(
                        icon: Icons.book,
                        isActive: index == 1,
                        isDark: isDark,
                        onTap: () => onNav(1),
                      ),
                      const SizedBox(height: 8),
                      _NavItem(
                        icon: Icons.calendar_today,
                        isActive: index == 2,
                        isDark: isDark,
                        onTap: () => onNav(2),
                      ),
                      const SizedBox(height: 8),
                      _NavItem(
                        icon: Icons.grade,
                        isActive: index == 3,
                        isDark: isDark,
                        onTap: () => onNav(3),
                      ),
                      const SizedBox(height: 8),
                      _NavItem(
                        icon: Icons.support_agent,
                        isActive: index == 4,
                        isDark: isDark,
                        onTap: () => onNav(4),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (user.role == "teacher")
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: _NavItem(
                      icon: Icons.add_moderator_outlined,
                      isActive: index == 5,
                      isDark: isDark,
                      onTap: () => onNav(5),
                      // label: "Teacher Panel",
                    ),
                  ),
                // User Profile Section
                UserCard3(),
              ],
            ),
          );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  String? label;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  _NavItem({
    required this.icon,
    this.label,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isActive
        ? Theme.of(context).primaryColor.withOpacity(0.1)
        : isHovered
        ? (widget.isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6))
        : Colors.transparent;

    final textColor = widget.isActive
        ? Theme.of(context).primaryColor
        : (widget.isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280));

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(widget.icon, size: 24, color: textColor),
                const SizedBox(width: 12),
                Text(
                  widget.label ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
