import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/components/Header.dart';
import 'package:mac_app/src/desktop/screens/TeacherContentScreen.dart';
import 'package:mac_app/src/services/supabase_service.dart';
import 'package:mac_app/src/utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

class Teacherdashboard extends StatefulWidget {
  const Teacherdashboard({super.key});

  @override
  State<Teacherdashboard> createState() => _TeacherdashboardState();
}

class _TeacherdashboardState extends State<Teacherdashboard> with SingleTickerProviderStateMixin {
  final SupabaseService _supabaseService = SupabaseService();
  late Future<List<Map<String, dynamic>>> _submissionsFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _submissionsFuture = _supabaseService.getTeacherSubmissions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {
      _submissionsFuture = _supabaseService.getTeacherSubmissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
      child: Column(
        children: [
          Header(title: "Teacher Dashboard"),
          Material(
            color: Colors.white.withOpacity(0.5),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF4DA3B6),
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: const Color(0xFF4DA3B6),
              tabs: const [
                Tab(text: 'Overview', icon: Icon(Icons.dashboard_outlined)),
                Tab(text: 'Content', icon: Icon(Icons.school_outlined)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _OverviewTab(
                  submissionsFuture: _submissionsFuture,
                  onRefresh: _refresh,
                ),
                const TeacherContentScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class _OverviewTab extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> submissionsFuture;
  final VoidCallback onRefresh;

  const _OverviewTab({required this.submissionsFuture, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: submissionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${snapshot.error}"),
                ElevatedButton(
                  onPressed: onRefresh,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final submissions = snapshot.data ?? [];
        final padding = context.responsivePadding;

        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCards(submissions),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Submissions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                    tooltip: "Refresh Submissions",
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSubmissionsTable(submissions),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildSummaryCards(List<Map<String, dynamic>> submissions) {
    final int totalSubmissions = submissions.length;
    final int graded = submissions.where((s) => s['submission_status'] == 'graded').length;
    final int pending = submissions.where((s) => s['submission_status'] == 'submitted').length;

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _StatCard(
          title: "Total Submissions",
          value: totalSubmissions.toString(),
          icon: Icons.assignment_turned_in,
          color: const Color(0xFF4DA3B6),
        ),
        _StatCard(
          title: "Needs Grading",
          value: pending.toString(),
          icon: Icons.pending_actions,
          color: Colors.orange,
        ),
        _StatCard(
          title: "Graded",
          value: graded.toString(),
          icon: Icons.check_circle,
          color: Colors.green,
        ),
      ],
    );
  }

  static Widget _buildSubmissionsTable(List<Map<String, dynamic>> submissions) {
    if (submissions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              "No submissions yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: const [
                Expanded(flex: 2, child: _TableHeader("STUDENT")),
                Expanded(flex: 3, child: _TableHeader("ASSIGNMENT")),
                Expanded(flex: 2, child: _TableHeader("DATE SUBMITTED")),
                Expanded(flex: 2, child: _TableHeader("STATUS")),
                Expanded(flex: 2, child: _TableHeader("ACTION")),
              ],
            ),
          ),
          ...submissions.map((sub) => _SubmissionRow(submission: sub)),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade600,
        letterSpacing: 1,
      ),
    );
  }
}

class _SubmissionRow extends StatelessWidget {
  final Map<String, dynamic> submission;

  const _SubmissionRow({required this.submission});

  @override
  Widget build(BuildContext context) {
    final studentName = submission['users']?['name'] ?? 'Unknown Student';
    final assignmentTitle = submission['assignments']?['title'] ?? 'Unknown Assignment';
    final dateSubmitted = DateTime.parse(submission['submitted_at']).toLocal();
    final status = submission['submission_status'] ?? 'submitted';
    final List<dynamic> fileUrls = submission['file_urls'] ?? [];
    
    // Format date: MM/DD/YYYY, HH:mm AM/PM
    final formattedDate = "${dateSubmitted.month}/${dateSubmitted.day}/${dateSubmitted.year} "
        "${dateSubmitted.hour > 12 ? dateSubmitted.hour - 12 : dateSubmitted.hour == 0 ? 12 : dateSubmitted.hour}:${dateSubmitted.minute.toString().padLeft(2, '0')} "
        "${dateSubmitted.hour >= 12 ? 'PM' : 'AM'}";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: const Color(0xFF4DA3B6).withOpacity(0.2),
                  child: Text(
                    studentName.isNotEmpty ? studentName[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4DA3B6),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    studentName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              assignmentTitle,
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formattedDate,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _StatusChip(status: status),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                if (fileUrls.isNotEmpty)
                  TextButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(fileUrls.first.toString());
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not open file.')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.file_download, size: 16),
                    label: const Text('View File', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF4DA3B6),
                    ),
                  )
                else
                  Text(
                    'No File',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    
    switch (status.toLowerCase()) {
      case 'graded':
        color = Colors.green;
        label = 'GRADED';
        break;
      case 'late':
        color = Colors.red;
        label = 'LATE';
        break;
      case 'submitted':
      default:
        color = Colors.orange;
        label = 'NEEDS GRADING';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
