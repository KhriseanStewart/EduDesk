import 'package:flutter/material.dart';

class CurriculumSidebar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int>? onSelect;

  const CurriculumSidebar({Key? key, this.activeIndex = 1, this.onSelect})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: 288, // w-72
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: isDark ? const Color(0xFF264532) : Colors.grey.shade200,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              _Header(isDark: isDark),
              const SizedBox(height: 24),
              _SectionLabel(isDark: isDark, text: "Curriculum Map"),
              const SizedBox(height: 8),

              _NavItem(
                icon: Icons.dashboard,
                label: "Course Overview",
                index: 0,
                isActive: activeIndex == 0,
                isDark: isDark,
                onTap: onSelect,
              ),
              _NavItem(
                icon: Icons.memory,
                label: "Unit 1: Hardware",
                index: 1,
                isActive: activeIndex == 1,
                isDark: isDark,
                onTap: onSelect,
              ),
              _NavItem(
                icon: Icons.lan,
                label: "Unit 2: Networking",
                index: 2,
                isActive: activeIndex == 2,
                isDark: isDark,
                onTap: onSelect,
              ),
              _NavItem(
                icon: Icons.code_off,
                label: "Unit 3: Software",
                index: 3,
                isActive: activeIndex == 3,
                isDark: isDark,
                onTap: onSelect,
              ),
              _NavItem(
                icon: Icons.folder_open,
                label: "Resources",
                index: 4,
                isActive: activeIndex == 4,
                isDark: isDark,
                onTap: onSelect,
              ),

              const Spacer(),

              _ProgressCard(isDark: isDark),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isDark;
  const _Header({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF4DA3B6).withOpacity(isDark ? 0.2 : 0.1),
          ),
          child: const Icon(Icons.terminal, color: Color(0xFF4DA3B6), size: 28),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Introduction to ICT",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              "ICT-2024 Program",
              style: TextStyle(fontSize: 12, color: Color(0xFF96C5A9)),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final bool isDark;

  const _SectionLabel({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          letterSpacing: 1.4,
          fontWeight: FontWeight.bold,
          color: isDark
              ? const Color(0xFF96C5A9).withOpacity(0.5)
              : Colors.grey,
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isActive;
  final bool isDark;
  final ValueChanged<int>? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.isActive,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => onTap?.call(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isActive
              ? (isDark
                    ? const Color(0xFF264532)
                    : const Color(0xFF4DA3B6).withOpacity(0.1))
              : Colors.transparent,
          border: isActive
              ? Border.all(color: const Color(0xFF4DA3B6).withOpacity(0.2))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive
                  ? const Color(0xFF4DA3B6)
                  : (isDark ? const Color(0xFF96C5A9) : Colors.grey),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final bool isDark;
  const _ProgressCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B3123) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF264532) : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Unit Progress",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("7 of 12 Tasks", style: TextStyle(fontSize: 10)),
              Text(
                "58%",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4DA3B6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: 0.58,
              minHeight: 6,
              backgroundColor: Color(0xFF264532),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4DA3B6)),
            ),
          ),
        ],
      ),
    );
  }
}
