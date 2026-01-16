import 'package:flutter/material.dart';
import 'package:mac_app/src/LMS%20models/lms_models.dart';
import 'package:mac_app/src/components/BuildVideoPlayer.dart';
import 'package:mac_app/src/components/RouteName.dart';
import 'package:mac_app/src/components/WebView.dart';
import 'package:mac_app/src/main/MainLayout.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Lesson lesson;
  const CourseDetailsScreen({Key? key, required this.lesson}) : super(key: key);

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  bool isVideoHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Expanded(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                hitTestBehavior: HitTestBehavior.opaque,
                child: _buildMainContent(widget.lesson),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(Lesson lesson) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          RouteName(),
          const SizedBox(height: 12),
          Text(
            lesson.title,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Color(0xFF101918),
            ),
          ),
          const SizedBox(height: 40),
          // Video Player
          _buildVideoPlayer(widget.lesson),
          const SizedBox(height: 40),
          // Content Grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildLessonOverview(widget.lesson)),
              const SizedBox(width: 32),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildDownloadsCard(widget.lesson),
                    const SizedBox(height: 24),
                    _buildHelpCard(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          // Bottom Navigation
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(Lesson lesson) {
    final url = lesson.videoUrl ?? '';
    return url.contains("zoom")
        ? ZoomRecordingWebView(zoomUrl: url)
        : MouseRegion(
            onEnter: (_) => setState(() => isVideoHovered = true),
            onExit: (_) => setState(() => isVideoHovered = false),
            child: CourseVideoPlayer(videoUrl: url),
          );
  }

  Widget _buildLessonOverview(Lesson lesson) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lesson Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            lesson.content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDownloadsCard(Lesson lesson) {
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
          Text(
            'DOWNLOADS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lesson.resources.length,
            itemBuilder: (context, index) {
              final rrs = lesson.resources[index];
              return _DownloadItem(
                key: Key(rrs.id),
                icon: rrs.icon,
                iconBgColor: rrs.iconColor,
                iconColor: rrs.iconColor,
                title: rrs.title,
                subtitle: rrs.url,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF289F91),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Need Help?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'If you\'re stuck on this concept, reach out to your instructor or visit the student forum.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Contact Instructor',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text(
              'Previous',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF289F91),
                  side: BorderSide(
                    color: const Color(0xFF289F91).withOpacity(0.2),
                    width: 2,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Mark as Complete',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Text(
                  'Next Lesson',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                label: const Icon(Icons.arrow_forward, size: 18),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF289F91),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFF289F91).withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _DownloadItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  const _DownloadItem({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
