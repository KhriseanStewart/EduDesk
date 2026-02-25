import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mac_app/src/desktop/LMS models/lms_models.dart' hide User;

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseDb = Supabase.instance.client;

  // -- Users --
  Future<User?> getUser(String userId) async {
    try {
      final response = await SupabaseDb
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return User.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching user: $e');
      return null;
    }
  }

  // -- Courses --
  Future<List<Course>> getCourses() async {
    try {
      final response = await SupabaseDb.from('courses').select('''
        *,
        modules (
          *,
          lessons (
            *,
            resources (*),
            learning_objectives (*)
          )
        ),
        assignments (*)
      ''');
      return (response as List).map((json) => Course.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching courses: $e');
      return [];
    }
  }

  /// Find a course by its unique code (e.g. CS101). Returns null if not found.
  Future<Course?> getCourseByCode(String code) async {
    if (code.trim().isEmpty) return null;
    try {
      final response = await SupabaseDb.from('courses').select('''
        *,
        modules (
          *,
          lessons (
            *,
            resources (*),
            learning_objectives (*)
          )
        ),
        assignments (*)
      ''').eq('code', code.trim().toUpperCase()).maybeSingle();
      if (response == null) return null;
      return Course.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching course by code: $e');
      return null;
    }
  }

  /// Enroll the current user (student) in a course. Requires student_id to exist in public.users.
  Future<void> enrollStudentInCourse({required String courseId, required String studentId}) async {
    try {
      await SupabaseDb.from('course_enrollments').insert({
        'course_id': courseId,
        'student_id': studentId,
        'status': 'active',
        'progress': 0,
        'completed_modules': 0,
        'total_modules': 0,
      });
    } catch (e) {
      debugPrint('Error enrolling student: $e');
      rethrow;
    }
  }

  /// Returns course ids the student is enrolled in.
  Future<List<String>> getEnrolledCourseIds(String studentId) async {
    if (studentId.isEmpty) return [];
    try {
      final response = await SupabaseDb.from('course_enrollments')
          .select('course_id')
          .eq('student_id', studentId)
          .eq('status', 'active');
      return (response as List).map((e) => e['course_id'] as String).toList();
    } catch (e) {
      debugPrint('Error fetching enrollments: $e');
      return [];
    }
  }

  /// Returns full courses the student is enrolled in (for "My Courses" list).
  Future<List<Course>> getEnrolledCourses(String studentId) async {
    if (studentId.isEmpty) return [];
    try {
      final ids = await getEnrolledCourseIds(studentId);
      if (ids.isEmpty) return [];
      final response = await SupabaseDb.from('courses').select('''
        *,
        modules (
          *,
          lessons (
            *,
            resources (*),
            learning_objectives (*)
          )
        ),
        assignments (*)
      ''').inFilter('id', ids);
      return (response as List).map((json) => Course.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching enrolled courses: $e');
      return [];
    }
  }

  // -- Announcements --
  Future<List<Announcement>> getAnnouncements() async {
    try {
      final response = await SupabaseDb.from('announcements')
          .select()
          .order('posted_date', ascending: false);
      return (response as List).map((json) => Announcement.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching announcements: $e');
      return [];
    }
  }

  // -- Deadlines --
  Future<List<Deadline>> getUpcomingDeadlines() async {
    try {
      final response = await SupabaseDb.from('deadlines')
          .select()
          .order('due_date', ascending: true);
      return (response as List).map((json) => Deadline.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching deadlines: $e');
      return [];
    }
  }

  // -- Schedule Events --
  Future<List<ScheduleEvent>> getScheduleEvents() async {
    try {
      final response = await SupabaseDb.from('schedule_events')
          .select()
          .order('start_time', ascending: true);
      return (response as List).map((json) => ScheduleEvent.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching schedule events: $e');
      return [];
    }
  }

  // -- Grades --
  Future<List<Grade>> getGrades() async {
    try {
      final response = await SupabaseDb.from('grades')
          .select('''
            *,
            course_enrollments (*),
            courses (*)
          ''');
      return (response as List).map((json) {
        return Grade(
          courseId: json['course_id'] ?? '',
          courseCode: json['courses']?['code'] ?? '',
          courseName: json['courses']?['title'] ?? '',
          semester: json['semester'] ?? '',
          credits: (json['credits'] ?? 3.0).toDouble(),
          letterGrade: json['letter_grade'] ?? '--',
          numericGrade: (json['numeric_grade'])?.toDouble(),
          isPassed: json['is_passed'] ?? false,
          isInProgress: json['is_in_progress'] ?? false,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching grades: $e');
      return [];
    }
  }

  // -- Assignments --
  Future<void> submitAssignment({
    required String assignmentId,
    required String studentId,
    required String enrollmentId,
    required File file,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      
      // Upload file
      await SupabaseDb.storage
          .from('submissions')
          .upload(fileName, file);

      final fileUrl = SupabaseDb.storage.from('submissions').getPublicUrl(fileName);

      // Insert submission record
      await SupabaseDb.from('assignment_submissions').insert({
        'assignment_id': assignmentId,
        'student_id': studentId,
        'enrollment_id': enrollmentId,
        'submission_status': 'submitted',
        'submitted_at': DateTime.now().toIso8601String(),
        'file_urls': [fileUrl],
      });
      
    } catch (e) {
      debugPrint('Error submitting assignment: $e');
      throw e;
    }
  }

  // -- Submissions --
  Future<List<Map<String, dynamic>>> getTeacherSubmissions() async {
    try {
      final response = await SupabaseDb.from('assignment_submissions')
          .select('''
            *,
            assignments (title, course_id),
            users (name, email)
          ''')
          .order('submitted_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching submissions: $e');
      return [];
    }
  }

  // -- Users --
  Future<List<User?>> getUsersByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    try {
      final response = await SupabaseDb.from('users').select().inFilter('id', ids);
      return (response as List).map((json) => User.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching users: $e');
      return [];
    }
  }

  // ========== TEACHER: Course CRUD ==========
  // Schema: courses.created_by uuid REFERENCES public.users(id).
  // Use Supabase auth currentUser.id; that id must exist in public.users (e.g. sync from auth.users on signup).
  /// [createdByUid] = auth currentUser.id so the course appears in "My courses" (filtered by created_by).
  Future<String?> createCourse({
    required String title,
    required String code,
    required String instructor,
    required String instructorEmail,
    required String? createdByUid,
    String category = 'General',
    String categoryColor = '#4DA3B6',
    String imageUrl = '',
    String description = '',
    String semester = '',
    double credits = 3.0,
    bool isActive = true,
  }) async {
    try {
      final data = <String, dynamic>{
        'title': title,
        'code': code,
        'instructor': instructor,
        'instructor_email': instructorEmail,
        'category': category,
        'category_color': categoryColor,
        'image_url': imageUrl,
        'description': description,
        'semester': semester,
        'credits': credits,
        'is_active': isActive,
      };
      if (createdByUid != null && createdByUid.isNotEmpty) {
        data['created_by'] = createdByUid;
      }
      final res = await SupabaseDb.from('courses').insert(data).select('id').single();
      return res['id'] as String?;
    } catch (e) {
      debugPrint('Error creating course: $e');
      rethrow;
    }
  }

  Future<void> updateCourse({
    required String id,
    String? title,
    String? code,
    String? instructor,
    String? instructorEmail,
    String? category,
    String? categoryColor,
    String? imageUrl,
    String? description,
    String? semester,
    double? credits,
    bool? isActive,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (title != null) data['title'] = title;
      if (code != null) data['code'] = code;
      if (instructor != null) data['instructor'] = instructor;
      if (instructorEmail != null) data['instructor_email'] = instructorEmail;
      if (category != null) data['category'] = category;
      if (categoryColor != null) data['category_color'] = categoryColor;
      if (imageUrl != null) data['image_url'] = imageUrl;
      if (description != null) data['description'] = description;
      if (semester != null) data['semester'] = semester;
      if (credits != null) data['credits'] = credits;
      if (isActive != null) data['is_active'] = isActive;
      if (data.isEmpty) return;
      await SupabaseDb.from('courses').update(data).eq('id', id);
    } catch (e) {
      debugPrint('Error updating course: $e');
      rethrow;
    }
  }

  Future<void> deleteCourse(String id) async {
    try {
      await SupabaseDb.from('courses').delete().eq('id', id);
    } catch (e) {
      debugPrint('Error deleting course: $e');
      rethrow;
    }
  }

  /// Returns courses where created_by = [uid] (Supabase auth currentUser.id).
  /// Schema: courses.created_by uuid REFERENCES public.users(id). Existing rows with created_by NULL won't appear until you set created_by to your user id in Supabase.
  Future<List<Course>> getCoursesForCurrentUser(String? uid) async {
    if (uid == null || uid.isEmpty) return [];
    try {
      final response = await SupabaseDb.from('courses').select('''
        *,
        modules (
          *,
          lessons (
            *,
            resources (*),
            learning_objectives (*)
          )
        ),
        assignments (*)
      ''').eq('created_by', uid);
      return (response as List).map((json) => Course.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching courses for current user: $e');
      return [];
    }
  }

  // ========== TEACHER: Module CRUD ==========
  Future<String?> createModule({
    required String courseId,
    required String title,
    String description = '',
    int orderNo = 0,
    bool isActive = true,
    bool isLocked = false,
  }) async {
    try {
      final res = await SupabaseDb.from('modules').insert({
        'course_id': courseId,
        'title': title,
        'description': description,
        'order_no': orderNo,
        'is_active': isActive,
        'is_locked': isLocked,
      }).select('id').single();
      return res['id'] as String?;
    } catch (e) {
      debugPrint('Error creating module: $e');
      rethrow;
    }
  }

  Future<void> updateModule({
    required String id,
    String? title,
    String? description,
    int? orderNo,
    bool? isActive,
    bool? isLocked,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (orderNo != null) data['order_no'] = orderNo;
      if (isActive != null) data['is_active'] = isActive;
      if (isLocked != null) data['is_locked'] = isLocked;
      if (data.isEmpty) return;
      await SupabaseDb.from('modules').update(data).eq('id', id);
    } catch (e) {
      debugPrint('Error updating module: $e');
      rethrow;
    }
  }

  Future<void> deleteModule(String id) async {
    try {
      await SupabaseDb.from('modules').delete().eq('id', id);
    } catch (e) {
      debugPrint('Error deleting module: $e');
      rethrow;
    }
  }

  // ========== TEACHER: Lesson CRUD ==========
  Future<String?> createLesson({
    required String moduleId,
    required String title,
    String content = '',
    String? videoUrl,
    int orderNo = 0,
    int durationMinutes = 0,
    bool isActive = true,
  }) async {
    try {
      final res = await SupabaseDb.from('lessons').insert({
        'module_id': moduleId,
        'title': title,
        'content': content,
        'video_url': videoUrl,
        'order_no': orderNo,
        'duration_minutes': durationMinutes,
        'is_active': isActive,
      }).select('id').single();
      return res['id'] as String?;
    } catch (e) {
      debugPrint('Error creating lesson: $e');
      rethrow;
    }
  }

  Future<void> updateLesson({
    required String id,
    String? title,
    String? content,
    String? videoUrl,
    int? orderNo,
    int? durationMinutes,
    bool? isActive,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (title != null) data['title'] = title;
      if (content != null) data['content'] = content;
      if (videoUrl != null) data['video_url'] = videoUrl;
      if (orderNo != null) data['order_no'] = orderNo;
      if (durationMinutes != null) data['duration_minutes'] = durationMinutes;
      if (isActive != null) data['is_active'] = isActive;
      if (data.isEmpty) return;
      await SupabaseDb.from('lessons').update(data).eq('id', id);
    } catch (e) {
      debugPrint('Error updating lesson: $e');
      rethrow;
    }
  }

  // Learning objectives (separate table linked to lesson_id)
  Future<void> addLearningObjective({required String lessonId, required String objective, int orderNo = 0}) async {
    try {
      await SupabaseDb.from('learning_objectives').insert({
        'lesson_id': lessonId,
        'objective': objective,
        'order_no': orderNo,
      });
    } catch (e) {
      debugPrint('Error adding learning objective: $e');
      rethrow;
    }
  }

  Future<void> removeLearningObjective(String id) async {
    try {
      await SupabaseDb.from('learning_objectives').delete().eq('id', id);
    } catch (e) {
      debugPrint('Error removing learning objective: $e');
      rethrow;
    }
  }

  // Resources (separate table linked to lesson_id)
  Future<void> addResource({
    required String lessonId,
    required String title,
    required String url,
    String fileType = 'file',
    String fileSize = '0 KB',
  }) async {
    try {
      await SupabaseDb.from('resources').insert({
        'lesson_id': lessonId,
        'title': title,
        'url': url,
        'file_type': fileType,
        'file_size': fileSize,
      });
    } catch (e) {
      debugPrint('Error adding resource: $e');
      rethrow;
    }
  }

  /// Uploads a file to Supabase Storage bucket [bucketName] and returns the public URL.
  /// Use for lesson resources (PDF, etc.). Create bucket "resources" in Supabase Storage with public read if needed.
  Future<String> uploadResourceFile(File file, {String bucketName = 'resources'}) async {
    final name = file.path.split(RegExp(r'[/\\]')).last;
    final path = '${DateTime.now().millisecondsSinceEpoch}_${name}';
    await SupabaseDb.storage.from(bucketName).upload(path, file, fileOptions: const FileOptions(upsert: true));
    return SupabaseDb.storage.from(bucketName).getPublicUrl(path);
  }

  /// Picks file, uploads to storage, then adds resource record for the lesson.
  Future<void> addResourceFromFile({
    required File file,
    required String lessonId,
    String? title,
  }) async {
    final url = await uploadResourceFile(file);
    final name = title ?? file.path.split(RegExp(r'[/\\]')).last;
    final ext = name.contains('.') ? name.split('.').last.toLowerCase() : 'file';
    final sizeBytes = await file.length();
    final fileSize = sizeBytes >= 1024 * 1024
        ? '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB'
        : '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    await addResource(
      lessonId: lessonId,
      title: name,
      url: url,
      fileType: ext,
      fileSize: fileSize,
    );
  }

  Future<void> removeResource(String id) async {
    try {
      await SupabaseDb.from('resources').delete().eq('id', id);
    } catch (e) {
      debugPrint('Error removing resource: $e');
      rethrow;
    }
  }

  // ========== TEACHER: Assignment CRUD ==========
  Future<String?> createAssignment({
    required String courseId,
    required String moduleId,
    required String title,
    String description = '',
    required DateTime dueDate,
    double totalPoints = 100.0,
    List<String> acceptedFormats = const ['pdf', 'doc', 'docx'],
    double maxFileSizeMb = 10.0,
    String? lessonId,
  }) async {
    try {
      final res = await SupabaseDb.from('assignments').insert({
        'course_id': courseId,
        'module_id': moduleId,
        'lesson_id': lessonId,
        'title': title,
        'description': description,
        'due_date': dueDate.toIso8601String(),
        'total_points': totalPoints,
        'accepted_formats': acceptedFormats,
        'max_file_size_mb': maxFileSizeMb,
      }).select('id').single();
      return res['id'] as String?;
    } catch (e) {
      debugPrint('Error creating assignment: $e');
      rethrow;
    }
  }

  Future<void> updateAssignment({
    required String id,
    String? title,
    String? description,
    DateTime? dueDate,
    double? totalPoints,
    List<String>? acceptedFormats,
    double? maxFileSizeMb,
    String? lessonId,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (dueDate != null) data['due_date'] = dueDate.toIso8601String();
      if (totalPoints != null) data['total_points'] = totalPoints;
      if (acceptedFormats != null) data['accepted_formats'] = acceptedFormats;
      if (maxFileSizeMb != null) data['max_file_size_mb'] = maxFileSizeMb;
      if (lessonId != null) data['lesson_id'] = lessonId;
      if (data.isEmpty) return;
      await SupabaseDb.from('assignments').update(data).eq('id', id);
    } catch (e) {
      debugPrint('Error updating assignment: $e');
      rethrow;
    }
  }
}
