import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/LMS%20models/lms_models.dart';
import 'package:mac_app/src/desktop/sub-screens/screen/CourseDetails.dart';
import 'package:mac_app/src/mobile/sub-screens/AssignmentSubmissionScreen.dart';

class Sublayout extends StatefulWidget {
  const Sublayout({super.key});

  @override
  State<Sublayout> createState() => _SublayoutState();
}

class _SublayoutState extends State<Sublayout> {
  Lesson? selectedLesson;
  String? selectedAssignmentId;
  bool showMobileSidebar = false;
  int currentAssignmentIndex = 0;

  int currentIndex = 0;
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
      return Scaffold(
        body: Row(
          children: [
            // SizedBox(width: 320, child: _buildSidebar(modules, course)),
            Expanded(child: Center(child: Text('No modules available'))),
          ],
        ),
      );
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

    final List<Widget> _screen = [
      CourseDetailsScreen(lesson: defaultLesson),
      AssignmentSubmissionScreen(
        assignment: displayAssignment ?? assignments.first,
        onNext: () async {
          setState(() {
            if (currentAssignmentIndex < assignments.length - 1) {
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
      Placeholder(),
    ];
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: _screen[currentIndex]),
      drawer: Drawer(),
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
}
