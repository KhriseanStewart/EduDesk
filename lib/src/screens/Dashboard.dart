// lib/src/screens/Dashboard.dart - UPDATED

import 'package:flutter/material.dart';
import 'package:mac_app/src/LMS%20models/lms_models.dart';
import 'package:mac_app/src/components/CourseCard.dart';
import 'package:mac_app/src/components/StickySidebar.dart';
import 'package:mac_app/src/data/mockData.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final activeCourses = MockData.courses.where((c) => c.isActive).toList();
    final announcement = MockData.announcements.firstWhere((a) => a.isPinned);

    print(size.width);

    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    size.width > 1302
                        ? _buildAnnouncementBanner(context, announcement)
                        : const SizedBox.shrink(),
                    const SizedBox(height: 16),
                    _buildCurrentCourses(context, size, activeCourses),
                    const SizedBox(height: 24),
                    _buildQuickStats(activeCourses),
                  ],
                ),
              ),
            ),
            // Fixed sticky sidebar
            size.width > 1302
                ? SizedBox(
                    width: size.width * 0.3,
                    child: const StickySidebar(),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementBanner(
    BuildContext context,
    Announcement announcement,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD54F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFD54F).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFFFD54F),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.campaign, color: Color(0xFF1A2B2E), size: 26),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  announcement.message,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD54F),
              foregroundColor: const Color(0xFF1A2B2E),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "View Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentCourses(BuildContext context, Size size, List courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Current Courses",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 15),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisExtent: 300,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            maxCrossAxisExtent: 420,
            childAspectRatio: size.width > 1201 ? 1 : 1.35,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return CourseCard(
              imageurl: course.imageUrl,
              title: course.title,
              instructor: course.instructor,
              progress: course.progress,
              statusText: course.statusText,
              primaryColor: course.categoryColor,
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickStats(List courses) {
    final totalModules = courses.fold<int>(
      0,
      (int sum, c) => sum + (c.totalModules as int),
    );
    final completedModules = courses.fold<int>(
      0,
      (int sum, c) => sum + (c.completedModules as int),
    );
    final avgProgress = courses.isEmpty
        ? 0.0
        : courses.fold<double>(
                0.0,
                (double sum, c) => sum + (c.progress as num).toDouble(),
              ) /
              courses.length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Learning Progress Overview",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: "Total Courses",
                value: courses.length.toString(),
                color: const Color(0xFF4DA3B6),
              ),
              _StatItem(
                label: "Modules Completed",
                value: "$completedModules / $totalModules",
                color: Colors.green,
              ),
              _StatItem(
                label: "Avg. Progress",
                value: "${(avgProgress * 100).toInt()}%",
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
