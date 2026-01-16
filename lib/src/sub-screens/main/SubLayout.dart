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

  @override
  Widget build(BuildContext context) {
    // Safe argument extraction with early return
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      // Schedule navigation after build completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pop(context);
        }
      });
      return const SizedBox.shrink();
    }

    final List<Module> modules = args['modules'] ?? [];
    final List<Assignment> assignments = args['assignments'] ?? [];

    // Handle empty modules gracefully
    if (modules.isEmpty) {
      return const Scaffold(body: Center(child: Text('No modules available')));
    }

    final Lesson defaultLesson = modules.first.lessons.first;
    Lesson? nextLesson = _findNextIncompleteLesson(modules);
    final Assignment? currentAssignment = _findCurrentAssignment(
      assignments,
      nextLesson?.id,
    );
    final Assignment defaultAssignment = assignments.isNotEmpty
        ? assignments.first
        : Assignment(
            lessonId: '',
            id: '',
            title: '',
            description: '',
            dueDate: DateTime.now(),
            totalPoints: 1,
            acceptedFormats: [],
            maxFileSizeMB: 1,
            courseId: '',
            moduleId: '',
          );

    return Scaffold(
      body: Row(
        children: [
          SizedBox(width: 320, child: _buildSidebar(modules)),
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(index: currentIndex),
                _buildMainContent(
                  currentIndex: currentIndex,
                  selectedLesson: selectedLesson,
                  nextLesson: nextLesson,
                  defaultLesson: defaultLesson,
                  currentAssignment: currentAssignment,
                  defaultAssignment: defaultAssignment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Extract next lesson logic
  Lesson? _findNextIncompleteLesson(List<Module> modules) {
    for (final mod in modules) {
      if (mod.isLocked) continue;

      for (final lesson in mod.lessons) {
        if (!lesson.isCompleted) {
          return lesson;
        }
      }
    }
    return null;
  }

  // Extract assignment finding logic
  Assignment? _findCurrentAssignment(
    List<Assignment> assignments,
    String? lessonId,
  ) {
    if (lessonId == null) return null;

    final currentAssignments = assignments
        .where((a) => a.moduleId == lessonId)
        .toList();

    return currentAssignments.isNotEmpty ? currentAssignments.first : null;
  }

  // Extract main content switching logic
  Widget _buildMainContent({
    required int currentIndex,
    required Lesson? selectedLesson,
    required Lesson? nextLesson,
    required Lesson defaultLesson,
    required Assignment? currentAssignment,
    required Assignment defaultAssignment,
  }) {
    switch (currentIndex) {
      case 0:
        return Expanded(
          child: CourseDetailsScreen(
            lesson: selectedLesson ?? nextLesson ?? defaultLesson,
          ),
        );
      case 1:
        return Expanded(
          child: AssignmentSubmissionScreen(
            assignment: currentAssignment ?? defaultAssignment,
          ),
        );
      case 2:
        return const Expanded(child: GradesTranscriptScreen());
      default:
        return Expanded(
          child: CourseDetailsScreen(
            lesson: selectedLesson ?? nextLesson ?? defaultLesson,
          ),
        );
    }
  }

  Widget _buildTopHeader({required int index}) {
    const primaryColor = Color(0xFF289F91);
    final inactiveColor = Colors.grey.shade600;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: const Border(bottom: BorderSide(color: Color(0xFFE9F1F0))),
      ),
      child: Row(
        children: [
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
          const Text(
            'EDUDESK',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 32),
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
          const Spacer(),
          _buildSearchBar(),
          const SizedBox(width: 16),
          const UserCard(),
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
      onPressed: () {
        setState(() {
          this.currentIndex = targetIndex;
        });
      },
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
      width: 256,
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

  Widget _buildSidebar(List<Module> modules) {
    return Container(
      width: 320,
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
                    const Text(
                      'Introduction to ICT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildProgressBar(),
                    const SizedBox(height: 32),
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

  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Course Progress',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              '75%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF289F91),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: 0.75,
            backgroundColor: const Color(0xFFE9F1F0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF289F91)),
            minHeight: 8,
          ),
        ),
      ],
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
                    });
                  },
                  isCompleted: lesson.isCompleted,
                  title: lesson.title,
                  isActive: lesson.isActive,
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildBottomActions() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFE9F1F0))),
          ),
          child: OutlinedButton.icon(
            label: const Text("Go back"),
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainLayout()),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE9F1F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE9F1F0),
                  foregroundColor: const Color(0xFF289F91),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.map, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Course Map',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Supporting Widgets
class _ModuleSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? const Color(0xFF289F91)
                        : Colors.grey.shade400,
                    letterSpacing: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isCompleted)
                const Icon(
                  Icons.check_circle,
                  size: 18,
                  color: Color(0xFF7BC950),
                ),
              if (isLocked)
                Icon(Icons.lock, size: 18, color: Colors.grey.shade400),
            ],
          ),
        ),
        ...lessons,
      ],
    );
  }
}

class _LessonItem extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final bool isActive;
  final VoidCallback? onTap;

  const _LessonItem({
    required this.title,
    this.isCompleted = false,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF289F91).withOpacity(0.12) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isCompleted
                  ? Icons.check
                  : isActive
                  ? Icons.play_circle
                  : Icons.circle_outlined,
              size: 18,
              color: isActive
                  ? const Color(0xFF289F91)
                  : isCompleted
                  ? Colors.grey.shade500
                  : Colors.grey.shade400,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive
                      ? const Color(0xFF289F91)
                      : isCompleted
                      ? Colors.grey.shade500
                      : Colors.black87,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
