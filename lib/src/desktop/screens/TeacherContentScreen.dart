import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/LMS models/lms_models.dart';
import 'package:mac_app/src/services/supabase_service.dart';
import 'package:mac_app/src/utils/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const List<String> _defaultCategories = [
  'General',
  'Programming',
  'Math',
  'Science',
  'Arts',
  'Tech',
  'Other',
];

List<String> _categoryDropdownItems(String? currentValue) {
  final set = _defaultCategories.toSet();
  if (currentValue != null &&
      currentValue.isNotEmpty &&
      !set.contains(currentValue)) {
    return [currentValue, ..._defaultCategories];
  }
  return List.from(_defaultCategories);
}

class TeacherContentScreen extends StatefulWidget {
  const TeacherContentScreen({super.key});

  @override
  State<TeacherContentScreen> createState() => _TeacherContentScreenState();
}

class _TeacherContentScreenState extends State<TeacherContentScreen> {
  final SupabaseService _supabase = SupabaseService();
  late Future<List<Course>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _loadMyCourses();
  }

  Future<List<Course>> _loadMyCourses() async {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    return _supabase.getCoursesForCurrentUser(uid);
  }

  void _refresh() {
    setState(() {
      _coursesFuture = _loadMyCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = context.responsivePadding;
    final maxW = context.isLargeOrWider ? 1200.0 : double.infinity;
    return FutureBuilder<List<Course>>(
      future: _coursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.red[700]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _refresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        final courses = snapshot.data ?? [];
        return Container(
          color: Colors.grey.shade50,
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(padding, padding, padding, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, padding),
                      SizedBox(height: context.isCompact ? 20 : 32),
                      if (courses.isEmpty)
                        _EmptyState(
                          message:
                              'No courses yet. Create your first course to add modules, lessons, and assignments.',
                          onAdd: () =>
                              _showAddCourseDialog(context, onSaved: _refresh),
                        )
                      else
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final useGrid =
                                constraints.maxWidth > Breakpoint.medium &&
                                courses.length > 1;
                            if (useGrid) {
                              return Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                children: courses
                                    .map(
                                      (course) => SizedBox(
                                        width:
                                            constraints.maxWidth >
                                                Breakpoint.large
                                            ? (constraints.maxWidth - 20) / 2
                                            : constraints.maxWidth,
                                        child: _CourseCard(
                                          course: course,
                                          onRefresh: _refresh,
                                          onEditCourse: () =>
                                              _showEditCourseDialog(
                                                context,
                                                course,
                                                onSaved: _refresh,
                                              ),
                                          onDeleteCourse: () =>
                                              _confirmDeleteCourse(
                                                context,
                                                course,
                                                onSaved: _refresh,
                                              ),
                                          onAddModule: () =>
                                              _showAddModuleDialog(
                                                context,
                                                course.id,
                                                onSaved: _refresh,
                                              ),
                                          onAddAssignment: () =>
                                              _showAddAssignmentDialog(
                                                context,
                                                course,
                                                onSaved: _refresh,
                                              ),
                                          onEditModule: (m) =>
                                              _showEditModuleDialog(
                                                context,
                                                m,
                                                onSaved: _refresh,
                                              ),
                                          onDeleteModule: (m) =>
                                              _confirmDeleteModule(
                                                context,
                                                m,
                                                onSaved: _refresh,
                                              ),
                                          onAddLesson: (moduleId) =>
                                              _showAddLessonDialog(
                                                context,
                                                moduleId,
                                                onSaved: _refresh,
                                              ),
                                          onEditLesson: (l) =>
                                              _showEditLessonDialog(
                                                context,
                                                l,
                                                onSaved: _refresh,
                                              ),
                                          onAddResource: (l) =>
                                              _showAddResourceDialog(
                                                context,
                                                l,
                                                onSaved: _refresh,
                                              ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            }
                            return Column(
                              children: courses
                                  .map(
                                    (course) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 20,
                                      ),
                                      child: _CourseCard(
                                        course: course,
                                        onRefresh: _refresh,
                                        onEditCourse: () =>
                                            _showEditCourseDialog(
                                              context,
                                              course,
                                              onSaved: _refresh,
                                            ),
                                        onDeleteCourse: () =>
                                            _confirmDeleteCourse(
                                              context,
                                              course,
                                              onSaved: _refresh,
                                            ),
                                        onAddModule: () => _showAddModuleDialog(
                                          context,
                                          course.id,
                                          onSaved: _refresh,
                                        ),
                                        onAddAssignment: () =>
                                            _showAddAssignmentDialog(
                                              context,
                                              course,
                                              onSaved: _refresh,
                                            ),
                                        onEditModule: (m) =>
                                            _showEditModuleDialog(
                                              context,
                                              m,
                                              onSaved: _refresh,
                                            ),
                                        onDeleteModule: (m) =>
                                            _confirmDeleteModule(
                                              context,
                                              m,
                                              onSaved: _refresh,
                                            ),
                                        onAddLesson: (moduleId) =>
                                            _showAddLessonDialog(
                                              context,
                                              moduleId,
                                              onSaved: _refresh,
                                            ),
                                        onEditLesson: (l) =>
                                            _showEditLessonDialog(
                                              context,
                                              l,
                                              onSaved: _refresh,
                                            ),
                                        onAddResource: (l) =>
                                            _showAddResourceDialog(
                                              context,
                                              l,
                                              onSaved: _refresh,
                                            ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, double padding) {
    final isCompact = context.isCompact;
    return Container(
      padding: EdgeInsets.symmetric(vertical: isCompact ? 16 : 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Course content',
                  style: TextStyle(
                    fontSize: isCompact ? 22 : 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F181A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Courses you teach · Add modules, lessons, assignments & resources',
                  style: TextStyle(
                    fontSize: isCompact ? 13 : 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filled(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4DA3B6),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          SizedBox(width: isCompact ? 8 : 12),
          FilledButton.icon(
            onPressed: () => _showAddCourseDialog(context, onSaved: _refresh),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: Text(isCompact ? 'Course' : 'Add course'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF4DA3B6),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 16 : 20,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddResourceDialog(
    BuildContext context,
    Lesson lesson, {
    required VoidCallback onSaved,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: false,
    );
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not access file.')));
      }
      return;
    }
    final file = File(path);
    if (!await file.exists()) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('File not found.')));
      }
      return;
    }
    final titleCtrl = TextEditingController(text: result.files.single.name);
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Add resource'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lesson: ${lesson.title}',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Display name',
                  border: OutlineInputBorder(),
                  hintText: 'Leave blank to use file name',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await _supabase.addResourceFromFile(
                  file: file,
                  lessonId: lesson.id,
                  title: titleCtrl.text.trim().isEmpty
                      ? null
                      : titleCtrl.text.trim(),
                );
                if (context.mounted) {
                  Navigator.pop(ctx);
                  onSaved();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Resource uploaded.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
                }
              }
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  void _showAddCourseDialog(
    BuildContext context, {
    required VoidCallback onSaved,
  }) {
    final user = Supabase.instance.client.auth.currentUser;
    final titleCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final instructorCtrl = TextEditingController();
    final instructorEmailCtrl = TextEditingController(text: user?.email ?? '');
    final descriptionCtrl = TextEditingController();
    final semesterCtrl = TextEditingController();
    final creditsCtrl = TextEditingController(text: '3');
    String category = 'General';
    final categoryColorCtrl = TextEditingController(text: '#4DA3B6');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add course'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title *'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: codeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Code * (e.g. CS101)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: instructorCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Instructor name *',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: instructorEmailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Instructor email *',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: semesterCtrl,
                  decoration: const InputDecoration(labelText: 'Semester'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: creditsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Credits'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categoryDropdownItems(category)
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => category = v ?? 'General',
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: categoryColorCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Category color (hex)',
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty ||
                  codeCtrl.text.trim().isEmpty ||
                  instructorCtrl.text.trim().isEmpty ||
                  instructorEmailCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please fill required fields: Title, Code, Instructor, Email',
                    ),
                  ),
                );
                return;
              }
              try {
                final user = Supabase.instance.client.auth.currentUser;
                final currentEmail =
                    user?.email ?? instructorEmailCtrl.text.trim();
                await _supabase.createCourse(
                  title: titleCtrl.text.trim(),
                  code: codeCtrl.text.trim(),
                  instructor: instructorCtrl.text.trim(),
                  instructorEmail: currentEmail,
                  createdByUid: user?.id,
                  description: descriptionCtrl.text.trim(),
                  semester: semesterCtrl.text.trim(),
                  credits: double.tryParse(creditsCtrl.text.trim()) ?? 3.0,
                  category: category,
                  categoryColor: categoryColorCtrl.text.trim().isEmpty
                      ? '#4DA3B6'
                      : categoryColorCtrl.text.trim(),
                );
                if (context.mounted) {
                  Navigator.pop(ctx);
                  onSaved();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Course created.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCourse(
    BuildContext context,
    Course course, {
    required VoidCallback onSaved,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete course?'),
        content: Text(
          'Delete "${course.title}"? This will remove the course and all its modules, lessons, and assignments. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await _supabase.deleteCourse(course.id);
                if (context.mounted) {
                  Navigator.pop(ctx);
                  onSaved();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Course deleted.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditCourseDialog(
    BuildContext context,
    Course course, {
    required VoidCallback onSaved,
  }) {
    final titleCtrl = TextEditingController(text: course.title);
    final codeCtrl = TextEditingController(text: course.code);
    final instructorCtrl = TextEditingController(text: course.instructor);
    final instructorEmailCtrl = TextEditingController(
      text: course.instructorEmail,
    );
    final descriptionCtrl = TextEditingController(text: course.description);
    final semesterCtrl = TextEditingController(text: course.semester);
    final creditsCtrl = TextEditingController(text: course.credits.toString());
    String category = course.category;
    final categoryColorCtrl = TextEditingController(
      text:
          '#${course.categoryColor.value.toRadixString(16).substring(2).toUpperCase()}',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit course'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title *'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: codeCtrl,
                  decoration: const InputDecoration(labelText: 'Code *'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: instructorCtrl,
                  decoration: const InputDecoration(labelText: 'Instructor *'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: instructorEmailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Instructor email *',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: semesterCtrl,
                  decoration: const InputDecoration(labelText: 'Semester'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: creditsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Credits'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categoryDropdownItems(category)
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => category = v ?? 'General',
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: categoryColorCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Category color (hex)',
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await _supabase.updateCourse(
                  id: course.id,
                  title: titleCtrl.text.trim(),
                  code: codeCtrl.text.trim(),
                  instructor: instructorCtrl.text.trim(),
                  instructorEmail: instructorEmailCtrl.text.trim(),
                  description: descriptionCtrl.text.trim(),
                  semester: semesterCtrl.text.trim(),
                  credits: double.tryParse(creditsCtrl.text.trim()),
                  category: category,
                  categoryColor: categoryColorCtrl.text.trim().isEmpty
                      ? null
                      : categoryColorCtrl.text.trim(),
                );
                if (context.mounted) {
                  Navigator.pop(ctx);
                  onSaved();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Course updated.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddModuleDialog(
    BuildContext context,
    String courseId, {
    required VoidCallback onSaved,
  }) {
    final titleCtrl = TextEditingController();
    final descriptionCtrl = TextEditingController();
    final orderCtrl = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add module'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Module title *',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: orderCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Order'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter module title.')),
                );
                return;
              }
              try {
                await _supabase.createModule(
                  courseId: courseId,
                  title: titleCtrl.text.trim(),
                  description: descriptionCtrl.text.trim(),
                  orderNo: int.tryParse(orderCtrl.text.trim()) ?? 0,
                );
                if (context.mounted) {
                  Navigator.pop(ctx);
                  onSaved();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Module created.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteModule(
    BuildContext context,
    Module module, {
    required VoidCallback onSaved,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete module?'),
        content: Text(
          'Delete "${module.title}"? This will remove the module and all its lessons. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await _supabase.deleteModule(module.id);
                if (context.mounted) {
                  Navigator.pop(ctx);
                  onSaved();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Module deleted.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditModuleDialog(
    BuildContext context,
    Module module, {
    required VoidCallback onSaved,
  }) {
    final titleCtrl = TextEditingController(text: module.title);
    final descriptionCtrl = TextEditingController(text: module.description);
    final orderCtrl = TextEditingController(text: module.order.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit module'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Module title *',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: orderCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Order'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await _supabase.updateModule(
                  id: module.id,
                  title: titleCtrl.text.trim(),
                  description: descriptionCtrl.text.trim(),
                  orderNo: int.tryParse(orderCtrl.text.trim()),
                );
                if (context.mounted) {
                  Navigator.pop(ctx);
                  onSaved();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Module updated.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddLessonDialog(
    BuildContext context,
    String moduleId, {
    required VoidCallback onSaved,
  }) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    final videoUrlCtrl = TextEditingController();
    final orderCtrl = TextEditingController(text: '0');
    final durationCtrl = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add lesson'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Lesson title *',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Content'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: videoUrlCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Video URL (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: orderCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Order'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: durationCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Duration (minutes)',
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter lesson title.')),
                );
                return;
              }
              try {
                await _supabase.createLesson(
                  moduleId: moduleId,
                  title: titleCtrl.text.trim(),
                  content: contentCtrl.text.trim(),
                  videoUrl: videoUrlCtrl.text.trim().isEmpty
                      ? null
                      : videoUrlCtrl.text.trim(),
                  orderNo: int.tryParse(orderCtrl.text.trim()) ?? 0,
                  durationMinutes: int.tryParse(durationCtrl.text.trim()) ?? 0,
                );
                if (context.mounted) {
                  Navigator.pop(ctx);
                  onSaved();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lesson created.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditLessonDialog(
    BuildContext context,
    Lesson lesson, {
    required VoidCallback onSaved,
  }) {
    final titleCtrl = TextEditingController(text: lesson.title);
    final contentCtrl = TextEditingController(text: lesson.content);
    final videoUrlCtrl = TextEditingController(text: lesson.videoUrl ?? '');
    final orderCtrl = TextEditingController(text: lesson.order.toString());
    final durationCtrl = TextEditingController(
      text: lesson.durationMinutes.toString(),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit lesson'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Lesson title *',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Content'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: videoUrlCtrl,
                  decoration: const InputDecoration(labelText: 'Video URL'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: orderCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Order'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: durationCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Duration (minutes)',
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await _supabase.updateLesson(
                  id: lesson.id,
                  title: titleCtrl.text.trim(),
                  content: contentCtrl.text.trim(),
                  videoUrl: videoUrlCtrl.text.trim().isEmpty
                      ? null
                      : videoUrlCtrl.text.trim(),
                  orderNo: int.tryParse(orderCtrl.text.trim()),
                  durationMinutes: int.tryParse(durationCtrl.text.trim()),
                );
                if (context.mounted) {
                  Navigator.pop(ctx);
                  onSaved();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lesson updated.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddAssignmentDialog(
    BuildContext context,
    Course course, {
    required VoidCallback onSaved,
  }) {
    final titleCtrl = TextEditingController();
    final descriptionCtrl = TextEditingController();
    DateTime dueDate = DateTime.now().add(const Duration(days: 7));
    final pointsCtrl = TextEditingController(text: '100');
    String? selectedModuleId = course.modules.isNotEmpty
        ? course.modules.first.id
        : null;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add assignment'),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(labelText: 'Title *'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Due date'),
                      subtitle: Text(
                        '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}',
                      ),
                      trailing: TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: dueDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (picked != null)
                            setDialogState(() => dueDate = picked);
                        },
                        child: const Text('Pick date'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: pointsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Total points',
                      ),
                    ),
                    if (course.modules.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedModuleId,
                        decoration: const InputDecoration(labelText: 'Module'),
                        items: course.modules
                            .map(
                              (m) => DropdownMenuItem(
                                value: m.id,
                                child: Text(m.title),
                              ),
                            )
                            .toList(),
                        onChanged: (v) =>
                            setDialogState(() => selectedModuleId = v),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter assignment title.')),
                    );
                    return;
                  }
                  final moduleId =
                      selectedModuleId ??
                      (course.modules.isEmpty ? '' : course.modules.first.id);
                  if (moduleId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Add at least one module to the course first.',
                        ),
                      ),
                    );
                    return;
                  }
                  try {
                    await _supabase.createAssignment(
                      courseId: course.id,
                      moduleId: moduleId,
                      title: titleCtrl.text.trim(),
                      description: descriptionCtrl.text.trim(),
                      dueDate: dueDate,
                      totalPoints:
                          double.tryParse(pointsCtrl.text.trim()) ?? 100.0,
                    );
                    if (context.mounted) {
                      Navigator.pop(ctx);
                      onSaved();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Assignment created.')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final VoidCallback onAdd;

  const _EmptyState({required this.message, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.school_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add course'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF4DA3B6),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatefulWidget {
  final Course course;
  final VoidCallback onRefresh;
  final VoidCallback onEditCourse;
  final VoidCallback onDeleteCourse;
  final VoidCallback onAddModule;
  final VoidCallback onAddAssignment;
  final void Function(Module m) onEditModule;
  final void Function(Module m) onDeleteModule;
  final void Function(String moduleId) onAddLesson;
  final void Function(Lesson l) onEditLesson;
  final void Function(Lesson l) onAddResource;

  const _CourseCard({
    required this.course,
    required this.onRefresh,
    required this.onEditCourse,
    required this.onDeleteCourse,
    required this.onAddModule,
    required this.onAddAssignment,
    required this.onEditModule,
    required this.onDeleteModule,
    required this.onAddLesson,
    required this.onEditLesson,
    required this.onAddResource,
  });

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.course;
    final isCompact = context.isCompact;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(isCompact ? 16 : 24),
              child: Row(
                children: [
                  Container(
                    width: isCompact ? 44 : 56,
                    height: isCompact ? 44 : 56,
                    decoration: BoxDecoration(
                      color: c.categoryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: c.categoryColor,
                      size: isCompact ? 24 : 30,
                    ),
                  ),
                  SizedBox(width: isCompact ? 12 : 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.title,
                          style: TextStyle(
                            fontSize: isCompact ? 16 : 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${c.code} · ${c.modules.length} modules · ${c.assignments.length} assignments',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey.shade600,
                  ),
                  if (!isCompact) ...[
                    IconButton(
                      onPressed: widget.onEditCourse,
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Edit course',
                    ),
                    IconButton(
                      onPressed: widget.onDeleteCourse,
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red.shade700,
                      ),
                      tooltip: 'Delete course',
                    ),
                    TextButton.icon(
                      onPressed: widget.onAddModule,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Module'),
                    ),
                    TextButton.icon(
                      onPressed: widget.onAddAssignment,
                      icon: const Icon(Icons.assignment_add, size: 18),
                      label: const Text('Assignment'),
                    ),
                  ] else
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (v) {
                        if (v == 'edit')
                          widget.onEditCourse();
                        else if (v == 'delete')
                          widget.onDeleteCourse();
                        else if (v == 'module')
                          widget.onAddModule();
                        else if (v == 'assignment')
                          widget.onAddAssignment();
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 20),
                              SizedBox(width: 12),
                              Text('Edit course'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'module',
                          child: Row(
                            children: [
                              Icon(Icons.add, size: 20),
                              SizedBox(width: 12),
                              Text('Add module'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'assignment',
                          child: Row(
                            children: [
                              Icon(Icons.assignment_add, size: 20),
                              SizedBox(width: 12),
                              Text('Add assignment'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Delete course',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: EdgeInsets.fromLTRB(
                isCompact ? 16 : 24,
                0,
                isCompact ? 16 : 24,
                isCompact ? 16 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 1, color: Colors.grey.shade200),
                  SizedBox(height: isCompact ? 12 : 16),
                  Text(
                    'Modules & lessons',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: isCompact ? 8 : 12),
                  if (c.modules.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'No modules. Add a module first, then add lessons.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    )
                  else
                    ...c.modules.map(
                      (module) => _ModuleBlock(
                        module: module,
                        isCompact: isCompact,
                        onEditModule: widget.onEditModule,
                        onDeleteModule: widget.onDeleteModule,
                        onAddLesson: widget.onAddLesson,
                        onEditLesson: widget.onEditLesson,
                        onAddResource: widget.onAddResource,
                      ),
                    ),
                  SizedBox(height: isCompact ? 12 : 16),
                  Text(
                    'Assignments',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: isCompact ? 8 : 12),
                  if (c.assignments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'No assignments yet.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    )
                  else
                    ...c.assignments.map(
                      (a) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.assignment_outlined,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                        title: Text(
                          a.title,
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                          'Due ${a.dueDate.year}-${a.dueDate.month.toString().padLeft(2, '0')}-${a.dueDate.day.toString().padLeft(2, '0')} · ${a.totalPoints} pts',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ModuleBlock extends StatelessWidget {
  final Module module;
  final bool isCompact;
  final void Function(Module m) onEditModule;
  final void Function(Module m) onDeleteModule;
  final void Function(String moduleId) onAddLesson;
  final void Function(Lesson l) onEditLesson;
  final void Function(Lesson l) onAddResource;

  const _ModuleBlock({
    required this.module,
    required this.isCompact,
    required this.onEditModule,
    required this.onDeleteModule,
    required this.onAddLesson,
    required this.onEditLesson,
    required this.onAddResource,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(isCompact ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.folder_outlined,
                  size: 20,
                  color: const Color(0xFF4DA3B6),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    module.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => onEditModule(module),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  tooltip: 'Edit module',
                ),
                IconButton(
                  onPressed: () => onDeleteModule(module),
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red.shade700,
                  ),
                  tooltip: 'Delete module',
                ),
                FilledButton.tonalIcon(
                  onPressed: () => onAddLesson(module.id),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Lesson'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF4DA3B6).withOpacity(0.1),
                    foregroundColor: const Color(0xFF4DA3B6),
                  ),
                ),
              ],
            ),
            if (module.lessons.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...module.lessons.map(
                (lesson) => Padding(
                  padding: const EdgeInsets.only(left: 28, top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.play_lesson_outlined,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              lesson.title,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          TextButton(
                            onPressed: () => onEditLesson(lesson),
                            child: const Text('Edit'),
                          ),
                          TextButton.icon(
                            onPressed: () => onAddResource(lesson),
                            icon: const Icon(Icons.upload_file, size: 16),
                            label: const Text('Resource'),
                          ),
                        ],
                      ),
                      if (lesson.resources.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        ...lesson.resources.map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(left: 46),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.insert_drive_file,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    r.title,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
