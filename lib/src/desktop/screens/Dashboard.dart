import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/LMS%20models/lms_models.dart';
import 'package:mac_app/src/desktop/components/CourseCard.dart';
import 'package:mac_app/src/desktop/components/StickySidebar.dart';
import 'package:mac_app/src/services/supabase_service.dart';
import 'package:mac_app/src/desktop/sub-screens/main/SubLayout.dart';
import 'package:mac_app/src/utils/responsive.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final SupabaseService _supabaseService = SupabaseService();
  late Future<List<dynamic>> _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _dashboardDataFuture = Future.wait([
      _supabaseService.getCourses(),
      _supabaseService.getAnnouncements(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = context.responsivePadding;
    final showSidebar = size.width > Breakpoint.large;

    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 15),
        child: FutureBuilder<List<dynamic>>(
              future: _dashboardDataFuture,
              builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading dashboard: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data found.'));
            }

            final courses = snapshot.data![0] as List<Course>;
            final announcements = snapshot.data![1] as List<Announcement>;

            final activeCourses = courses.where((c) => c.isActive).toList();
            final announcement = announcements.isNotEmpty 
                ? announcements.firstWhere((a) => a.isPinned, orElse: () => announcements.first)
                : null;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Scrollable content area
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (showSidebar && announcement != null)
                          _buildAnnouncementBanner(context, announcement)
                        else
                          const SizedBox.shrink(),
                        const SizedBox(height: 16),
                        _buildCurrentCourses(context, size, activeCourses),
                        const SizedBox(height: 24),
                        _buildQuickStats(activeCourses),
                      ],
                    ),
                  ),
                ),
                if (showSidebar) SizedBox(width: padding),
                if (showSidebar)
                  SizedBox(
                    width: size.width > Breakpoint.xl ? 380 : size.width * 0.28,
                    child: const StickySidebar(),
                  ),
              ],
            );
              },
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

  Widget _buildCurrentCourses(BuildContext context, Size size, List<Course> courses) {
    if (courses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text("No courses available.", style: TextStyle(fontSize: 16)),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Current Courses",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 15),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossCount = context.courseGridCrossCount;
            final spacing = 18.0;
            final availableWidth = constraints.maxWidth - (crossCount - 1) * spacing;
            final cardWidth = availableWidth / crossCount;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                mainAxisExtent: (cardWidth * 0.85).clamp(300.0, 380.0),
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Sublayout(),
                    settings: RouteSettings(
                      arguments: {
                         "assignments": course.assignments,
                         "modules": course.modules,
                         "course": course,
                      },
                    ),
                  ),
                );
              },
              child: CourseCard(
                imageurl: course.imageUrl.isEmpty
                    ? "https://via.placeholder.com/150"
                    : course.imageUrl,
                title: course.title,
                instructor: course.instructor,
                progress: course.progress,
                statusText: course.statusText,
                primaryColor: course.categoryColor,
              ),
            );
          },
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickStats(List<Course> courses) {
    final totalModules = courses.fold<int>(
      0,
      (int sum, c) => sum + c.totalModules,
    );
    final completedModules = courses.fold<int>(
      0,
      (int sum, c) => sum + c.completedModules,
    );
    final avgProgress = courses.isEmpty
        ? 0.0
        : courses.fold<double>(
                0.0,
                (double sum, c) => sum + (c.progress),
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
