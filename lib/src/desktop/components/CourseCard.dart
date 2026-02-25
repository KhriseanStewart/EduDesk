import 'package:flutter/material.dart';

class CourseCard extends StatefulWidget {
  final String title;
  final String instructor;
  final double progress; // 0.0 → 1.0
  final String statusText;
  final Color primaryColor;
  final String imageurl;

  const CourseCard({
    Key? key,
    required this.title,
    required this.instructor,
    required this.progress,
    required this.statusText,
    required this.imageurl,
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // IMAGE HEADER
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.network(
                    widget.imageurl,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 100,
                      ),
                    ),
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
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // INSTRUCTOR
            Text(
              "Instructor: ${widget.instructor}",
              style: const TextStyle(fontSize: 14, color: Color(0xFF538893)),
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 16),

            // PROGRESS TEXT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "${(widget.progress * 100).round()}% Complete",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    widget.statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: widget.primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
