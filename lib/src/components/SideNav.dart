import 'package:flutter/material.dart';

class SideNav extends StatelessWidget {
  final Function(int) onNav;
  final int index;

  const SideNav({super.key, required this.index, required this.onNav});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 288,
      height: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        border: Border(
          right: BorderSide(
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB),
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
          // User Profile Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? const Color(0xFF1F2937)
                      : const Color(0xFFF3F4F6),
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuB1XGNKGzaBMT9b0dLcV7BDfW6lhiPNJdiI_v-W1LyN1ejq74NP3WPR6EcD0Jb0NRNCjtTCsgSGWdQSAFUceddY2Vqu_ohm5RR9vUJIeGnjHNdHpmUUhVT9MTNVeadrQRI7rdezvpOYoij1TLLMvnZnJVwyflSBKxAa60NWz8iPSzGxeHsdd5vGU9TGCPOgMEJOiyUKHhNsRzsOWoXeTSugbyYAmn8sUx63CaBxGvp-8L4kwRYgX3O9xK540JFHucSZtyE2N11OR7o',
                        ),
                        onError: (exception, stackTrace) => Icon(Icons.person),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Marcus Johnson',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF111827),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'ID: 20248812',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF6B7280),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.logout, color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
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
                  widget.label,
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
