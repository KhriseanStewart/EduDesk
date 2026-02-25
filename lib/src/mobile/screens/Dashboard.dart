import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/LMS%20models/lms_models.dart';
import 'package:mac_app/src/desktop/components/CourseCard.dart';
import 'package:mac_app/src/services/supabase_service.dart';
import 'package:mac_app/src/utils/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final SupabaseService _supabase = SupabaseService();
  late Future<List<dynamic>> _dashboardDataFuture;

  void _loadData() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    setState(() {
      _dashboardDataFuture = Future.wait([
        userId != null ? _supabase.getEnrolledCourses(userId) : _supabase.getCourses(),
        _supabase.getAnnouncements(),
      ]);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final padding = context.responsivePadding;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F181A),
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: _dashboardDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
                  ],
                ),
              );
            }
            final courses = snapshot.data?[0] as List<Course>? ?? [];
            final announcements = snapshot.data?[1] as List<Announcement>? ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (announcements.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
                    child: _buildAnnouncementBanner(context, announcements.first),
                  ),
                Expanded(
                  child: courses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.menu_book_rounded, size: 56, color: Colors.grey.shade400),
                              const SizedBox(height: 12),
                              Text(
                                'No courses yet',
                                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Go to Courses and join a class with a code',
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CourseCard(
                                title: course.title,
                                instructor: course.instructor,
                                progress: course.progress,
                                statusText: course.statusText,
                                imageurl: course.imageUrl,
                              ),
                            );
                          },
                        ),
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD54F),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.campaign,
                    color: Color(0xFF1A2B2E),
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        announcement.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            announcement.message,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
