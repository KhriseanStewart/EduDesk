import 'package:flutter/material.dart';
import 'package:mac_app/src/LMS%20models/lms_models.dart';
import 'package:mac_app/src/components/UserCard.dart';
import 'package:mac_app/src/main/MainLayout.dart';
import 'package:mac_app/src/sub-screens/screen/AssignmentSubmissionScreen.dart';
import 'package:mac_app/src/sub-screens/screen/CourseDetails.dart';
import 'package:mac_app/src/sub-screens/screen/GradesTranscript.dart';

class Sublayout extends StatefulWidget {
  const Sublayout({super.key});

  @override
  State<Sublayout> createState() => _SublayoutState();
}

class _SublayoutState extends State<Sublayout> {
  Lesson? selectedLesson;
  int currentIndex = 0;
  String? selectedAssignmentId;
  bool showMobileSidebar = false;
  int currentAssignmentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
      return const SizedBox.shrink();
    }

    final List<Module> modules = args['modules'] ?? [];
    final List<Assignment> assignments = args['assignments'] ?? [];
    final Course? course = args['course'];

    if (modules.isEmpty) {
      return const Scaffold(body: Center(child: Text('No modules available')));
    }

    final Lesson defaultLesson = modules.first.lessons.first;
    Lesson? nextLesson = _findNextIncompleteLesson(modules);
    final Assignment? currentAssignment = _findCurrentAssignment(
      assignments,
      nextLesson?.id,
    );

    final Lesson? activeLesson = selectedLesson ?? nextLesson;

    // Get the current assignment to display
    final Assignment? displayAssignment =
        assignments.isNotEmpty && currentAssignmentIndex < assignments.length
        ? assignments[currentAssignmentIndex]
        : (currentAssignment ?? assignments.firstOrNull);

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 1024;
          final isTablet =
              constraints.maxWidth > 768 && constraints.maxWidth <= 1024;

          if (isDesktop) {
            return Row(
              children: [
                SizedBox(width: 320, child: _buildSidebar(modules, course)),
                Expanded(
                  child: Column(
                    children: [
                      _buildTopHeader(index: currentIndex, isCompact: false),
                      Expanded(
                        child: _buildMainContent(
                          currentIndex: currentIndex,
                          selectedLesson: selectedLesson,
                          nextLesson: nextLesson,
                          defaultLesson: defaultLesson,
                          currentAssignment: currentAssignment,
                          defaultAssignment:
                              displayAssignment ?? assignments.first,
                          onNext: () async {
                            setState(() {
                              if (currentAssignmentIndex <
                                  assignments.length - 1) {
                                currentAssignmentIndex++;
                              }
                            });
                          },
                          onPrevious: () {
                            setState(() {
                              if (currentAssignmentIndex > 0) {
                                currentAssignmentIndex--;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Stack(
              children: [
                Column(
                  children: [
                    _buildTopHeader(index: currentIndex, isCompact: true),
                    Expanded(
                      child: _buildMainContent(
                        currentIndex: currentIndex,
                        selectedLesson: selectedLesson,
                        nextLesson: nextLesson,
                        defaultLesson: defaultLesson,
                        currentAssignment: currentAssignment,
                        defaultAssignment:
                            displayAssignment ?? assignments.first,
                        onNext: () async {
                          setState(() {
                            if (currentAssignmentIndex <
                                assignments.length - 1) {
                              currentAssignmentIndex++;
                            }
                          });
                        },
                        onPrevious: () {
                          setState(() {
                            if (currentAssignmentIndex > 0) {
                              currentAssignmentIndex--;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (showMobileSidebar)
                  GestureDetector(
                    onTap: () => setState(() => showMobileSidebar = false),
                    child: Container(color: Colors.black54),
                  ),
                if (showMobileSidebar)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: SizedBox(
                      width: 280,
                      child: _buildSidebar(modules, course),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }

  Lesson? _findNextIncompleteLesson(List<Module> modules) {
    for (final mod in modules) {
      if (mod.isLocked) continue;
      for (final lesson in mod.lessons) {
        if (!lesson.isCompleted) return lesson;
      }
    }
    return null;
  }

  Assignment? _findCurrentAssignment(
    List<Assignment> assignments,
    String? lessonId,
  ) {
    if (lessonId == null) return null;
    final currentAssignments = assignments
        .where((a) => a.lessonId == lessonId)
        .toList();
    return currentAssignments.isNotEmpty ? currentAssignments.first : null;
  }

  Widget _buildMainContent({
    required int currentIndex,
    required Lesson? selectedLesson,
    required Lesson? nextLesson,
    required Lesson defaultLesson,
    required Assignment? currentAssignment,
    required Assignment defaultAssignment,
    required VoidCallback onNext,
    required VoidCallback onPrevious,
  }) {
    switch (currentIndex) {
      case 0:
        return CourseDetailsScreen(
          lesson: selectedLesson ?? nextLesson ?? defaultLesson,
        );
      case 1:
        return AssignmentSubmissionScreen(
          assignment: defaultAssignment,
          onNext: onNext,
          onPrevious: onPrevious,
        );
      case 2:
        return const GradesTranscriptScreen();
      default:
        return CourseDetailsScreen(
          lesson: selectedLesson ?? nextLesson ?? defaultLesson,
        );
    }
  }

  Widget _buildTopHeader({required int index, required bool isCompact}) {
    const primaryColor = Color(0xFF289F91);
    final inactiveColor = Colors.grey.shade600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 16 : 24,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(bottom: BorderSide(color: Color(0xFFE9F1F0))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isCompact)
            IconButton(
              onPressed: () =>
                  setState(() => showMobileSidebar = !showMobileSidebar),
              icon: const Icon(Icons.menu),
              color: primaryColor,
            ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          if (!isCompact)
            const Text(
              'EDUDESK',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          if (!isCompact) const SizedBox(width: 32),
          if (!isCompact) ...[
            _buildNavButton(
              label: 'My Courses',
              targetIndex: 0,
              currentIndex: index,
              primaryColor: primaryColor,
              inactiveColor: inactiveColor,
            ),
            const SizedBox(width: 16),
            _buildNavButton(
              label: 'Assignments',
              targetIndex: 1,
              currentIndex: index,
              primaryColor: primaryColor,
              inactiveColor: inactiveColor,
            ),
            const SizedBox(width: 16),
            _buildNavButton(
              label: 'Grades',
              targetIndex: 2,
              currentIndex: index,
              primaryColor: primaryColor,
              inactiveColor: inactiveColor,
            ),
          ],
          const Spacer(),
          if (!isCompact) ...[
            _buildSearchBar(),
            const SizedBox(width: 16),
            const UserCard(),
          ] else ...[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
              color: Colors.grey.shade600,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required String label,
    required int targetIndex,
    required int currentIndex,
    required Color primaryColor,
    required Color inactiveColor,
  }) {
    final isActive = currentIndex == targetIndex;

    return TextButton(
      onPressed: () => setState(() => this.currentIndex = targetIndex),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? primaryColor : inactiveColor,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 240,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search curriculum...',
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.search, size: 18, color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildSidebar(List<Module> modules, Course? course) {
    final totalLessons = modules.fold<int>(
      0,
      (sum, m) => sum + m.lessons.length,
    );
    final completedLessons = modules.fold<int>(
      0,
      (sum, m) => sum + m.lessons.where((l) => l.isCompleted).length,
    );
    final progress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE9F1F0))),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (course != null) ...[
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: course.categoryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.book,
                              color: course.categoryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  course.code,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: course.categoryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ] else ...[
                      const Text(
                        'Introduction to ICT',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    _buildProgressBar(progress, completedLessons, totalLessons),
                    const SizedBox(height: 24),
                    Text(
                      'COURSE CONTENT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildModuleList(modules),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress, int completed, int total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF289F91).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF289F91).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Course Progress',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF289F91),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF289F91),
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$completed of $total lessons completed',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleList(List<Module> modules) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final module = modules[index];
        return _ModuleSection(
          title: module.title,
          isActive: module.isActive,
          isCompleted: module.isCompleted,
          isLocked: module.isLocked,
          lessons: module.lessons
              .map<Widget>(
                (lesson) => _LessonItem(
                  onTap: () {
                    setState(() {
                      selectedLesson = lesson;
                      currentIndex = 0;
                      showMobileSidebar = false;
                    });
                  },
                  isCompleted: lesson.isCompleted,
                  title: lesson.title,
                  isActive:
                      lesson.isActive || (selectedLesson?.id == lesson.id),
                  duration: lesson.durationMinutes,
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE9F1F0))),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainLayout()),
                );
              },
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text("Back to Courses"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                side: BorderSide(color: Colors.grey.shade300),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleSection extends StatefulWidget {
  final String title;
  final bool isCompleted;
  final bool isActive;
  final bool isLocked;
  final List<Widget> lessons;

  const _ModuleSection({
    required this.title,
    this.isCompleted = false,
    this.isActive = false,
    this.isLocked = false,
    required this.lessons,
  });

  @override
  State<_ModuleSection> createState() => _ModuleSectionState();
}

class _ModuleSectionState extends State<_ModuleSection> {
  bool isExpanded = true;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isActive || !widget.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.expand_more : Icons.chevron_right,
                  size: 20,
                  color: widget.isActive
                      ? const Color(0xFF289F91)
                      : Colors.grey.shade500,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: widget.isActive
                          ? const Color(0xFF289F91)
                          : widget.isLocked
                          ? Colors.grey.shade400
                          : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.isCompleted)
                  const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Color(0xFF7BC950),
                  )
                else if (widget.isLocked)
                  Icon(Icons.lock, size: 18, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
        if (isExpanded && !widget.isLocked) ...widget.lessons,
      ],
    );
  }
}

class _LessonItem extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final bool isActive;
  final int duration;
  final VoidCallback? onTap;

  const _LessonItem({
    required this.title,
    this.isCompleted = false,
    this.isActive = false,
    required this.duration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4, left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF289F91).withOpacity(0.12)
              : isCompleted
              ? Colors.grey.shade50
              : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? const Color(0xFF289F91).withOpacity(0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF289F91)
                    : isCompleted
                    ? Colors.green
                    : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted
                    ? Icons.check
                    : isActive
                    ? Icons.play_arrow
                    : Icons.circle_outlined,
                size: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isActive
                          ? const Color(0xFF289F91)
                          : isCompleted
                          ? Colors.grey.shade600
                          : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 10,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$duration min',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}