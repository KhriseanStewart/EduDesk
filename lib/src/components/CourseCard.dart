import 'package:flutter/material.dart';

class CourseCard extends StatefulWidget {
  final String title;
  final String instructor;
  final double progress; // 0.0 → 1.0
  final String statusText;
  final Color primaryColor;

  const CourseCard({
    Key? key,
    required this.title,
    required this.instructor,
    required this.progress,
    required this.statusText,
    this.primaryColor = const Color(0xFF4DA3B6),
  }) : super(key: key);

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A2B2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHovered
                ? widget.primaryColor.withOpacity(0.2)
                : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isHovered ? 0.15 : 0.08),
              blurRadius: isHovered ? 20 : 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE HEADER
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.asset(
                    "assets/ict.png",
                    height: 128,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 128,
                    width: double.infinity,
                    color: isHovered
                        ? Colors.transparent
                        : widget.primaryColor.withOpacity(0.2),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // TITLE
            Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            // INSTRUCTOR
            Text(
              "Instructor: ${widget.instructor}",
              style: const TextStyle(fontSize: 14, color: Color(0xFF538893)),
            ),

            const SizedBox(height: 16),

            // PROGRESS TEXT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${(widget.progress * 100).round()}% Complete",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // PROGRESS BAR
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: widget.progress,
                minHeight: 8,
                backgroundColor: isDark
                    ? const Color(0xFF2A3E42)
                    : const Color(0xFFE8F0F2),
                valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
