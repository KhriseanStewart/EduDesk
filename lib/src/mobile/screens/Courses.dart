import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/LMS%20models/lms_models.dart';
import 'package:mac_app/src/mobile/main/SubLayout.dart';
import 'package:mac_app/src/services/supabase_service.dart';
import 'package:mac_app/src/utils/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final SupabaseService _supabase = SupabaseService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Course>> _coursesFuture;

  String selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    setState(() {
      _coursesFuture = userId != null
          ? _supabase.getEnrolledCourses(userId)
          : _supabase.getCourses();
    });
  }

  String _filterLabel(String value) {
    switch (value) {
      case 'inProgress':
        return "In Progress";
      case 'completed':
        return "Completed";
      case 'upcoming':
        return "Upcoming";
      default:
        return "All";
    }
  }

  List<Course> _getFilteredCourses(List<Course> allCourses) {
    switch (selectedFilter) {
      case 'inProgress':
        return allCourses
            .where((c) => c.progress > 0 && c.progress < 1.0)
            .toList();
      case 'completed':
        return allCourses.where((c) => c.progress >= 1.0).toList();
      case 'upcoming':
        return allCourses.where((c) => c.progress == 0).toList();
      default:
        return allCourses;
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = context.responsivePadding;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('My Courses', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F181A),
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: _showJoinClassDialog,
            tooltip: 'Join class',
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: FutureBuilder<List<Course>>(
            future: _coursesFuture,
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
                      ElevatedButton(onPressed: _loadCourses, child: const Text('Retry')),
                    ],
                  ),
                );
              }
              final allCourses = snapshot.data ?? [];
              final filteredCourses = _getFilteredCourses(allCourses);

              if (allCourses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book_rounded, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No courses yet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to join a class with a course code',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _showJoinClassDialog,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Join class'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF4DA3B6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [_buildMobileFilterTrigger(allCourses)],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: filteredCourses.length,
                      itemBuilder: (context, index) {
                        final course = filteredCourses[index];
                        return _CourseCard(course: course);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4DA3B6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.school_rounded, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  const Text('EduDesk', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.add_rounded, color: Color(0xFF4DA3B6)),
              title: const Text('Join class', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _showJoinClassDialog();
              },
            ),
            ListTile(
              leading: Icon(Icons.refresh_rounded, color: Colors.grey.shade700),
              title: const Text('Refresh list'),
              onTap: () {
                Navigator.pop(context);
                _loadCourses();
              },
            ),
            const Divider(height: 24),
            ListTile(
              leading: Icon(Icons.info_outline_rounded, color: Colors.grey.shade700),
              title: const Text('Enter a course code from your instructor to join a class.'),
              subtitle: const Text('e.g. CS101'),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinClassDialog() {
    final codeController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Join a class',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the course code shared by your instructor',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Course code',
                  hintText: 'e.g. CS101',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.code_rounded),
                ),
                textCapitalization: TextCapitalization.characters,
                onSubmitted: (_) => _submitJoinCode(ctx, codeController.text.trim()),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => _submitJoinCode(ctx, codeController.text.trim()),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF4DA3B6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Join class'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitJoinCode(BuildContext context, String code) async {
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a course code.')),
      );
      return;
    }
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to join a class.')),
        );
      }
      return;
    }
    try {
      final course = await _supabase.getCourseByCode(code);
      if (!context.mounted) return;
      if (course == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No course found with code "$code".')),
        );
        return;
      }
      final enrolledIds = await _supabase.getEnrolledCourseIds(user.id);
      if (enrolledIds.contains(course.id)) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are already enrolled in this course.')),
        );
        return;
      }
      await _supabase.enrollStudentInCourse(courseId: course.id, studentId: user.id);
      if (context.mounted) {
        Navigator.pop(context);
        _loadCourses();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Joined "${course.title}" successfully.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not join: $e')),
        );
      }
    }
  }

  Widget _buildMobileFilterTrigger(List<Course> allCourses) {
    return InkWell(
      onTap: () => _openFilterSheet(allCourses),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_list, size: 18),
            const SizedBox(width: 6),
            Text(
              _filterLabel(selectedFilter),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more, size: 18),
          ],
        ),
      ),
    );
  }

  void _openFilterSheet(List<Course> allCourses) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Filter Courses",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildFilterOption('all', "All", allCourses.length),
              _buildFilterOption(
                'inProgress',
                "In Progress",
                allCourses
                    .where((c) => c.progress > 0 && c.progress < 1.0)
                    .length,
              ),
              _buildFilterOption(
                'completed',
                "Completed",
                allCourses.where((c) => c.progress >= 1.0).length,
              ),
              _buildFilterOption(
                'upcoming',
                "Upcoming",
                allCourses.where((c) => c.progress == 0).length,
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String value, String label, int count) {
    final isSelected = selectedFilter == value;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        setState(() => selectedFilter = value);
        Navigator.pop(context);
      },
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      trailing: count > 0
          ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(fontSize: 12),
            ),
          )
          : null,
    );
  }
}

class _CourseCard extends StatefulWidget {
  final Course course;

  const _CourseCard({required this.course});

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final pendingAssignments = widget.course.assignments
        .where((a) => (a.isSubmitted != true) && (a.isOverdue != true))
        .length;
    final overdueAssignments = widget.course.assignments
        .where((a) => a.isOverdue == true)
        .length;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Sublayout(),
              settings: RouteSettings(
                arguments: {
                  "assignments": widget.course.assignments,
                  "modules": widget.course.modules,
                  "course": widget.course,
                },
              ),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, isHovered ? -6 : 0, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovered
                  ? widget.course.categoryColor.withOpacity(0.5)
                  : Colors.grey.shade200,
              width: isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isHovered ? 0.15 : 0.06),
                blurRadius: isHovered ? 24 : 12,
                offset: Offset(0, isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Header
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        widget.course.imageUrl.isEmpty 
                            ? "https://via.placeholder.com/150" 
                            : widget.course.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        widget.course.category.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: widget.course.categoryColor,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  if (overdueAssignments > 0)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.warning,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "$overdueAssignments Overdue",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isHovered
                            ? widget.course.categoryColor
                            : Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.course.instructor,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.course.semester,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.credit_card,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${widget.course.credits} Credits",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    // const Spacer(),
                    // Progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${(widget.course.progress * 100).toInt()}% Complete",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${widget.course.completedModules}/${widget.course.totalModules} Modules",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: widget.course.progress,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.course.categoryColor,
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Assignments Info
                    if (pendingAssignments > 0 || overdueAssignments > 0)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: overdueAssignments > 0
                              ? Colors.red.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.assignment,
                              size: 14,
                              color: overdueAssignments > 0
                                  ? Colors.red
                                  : Colors.orange,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              overdueAssignments > 0
                                  ? "$overdueAssignments overdue"
                                  : "$pendingAssignments pending",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: overdueAssignments > 0
                                    ? Colors.red
                                    : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Sublayout(),
                              settings: RouteSettings(
                                arguments: {
                                  "assignments": widget.course.assignments,
                                  "modules": widget.course.modules,
                                  "course": widget.course,
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.course.categoryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Continue Learning",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
