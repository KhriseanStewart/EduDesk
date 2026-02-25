import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String studentId;
  final String email;
  final String avatarUrl;
  final String program;
  final String role;

  User({
    required this.role,
    required this.id,
    required this.name,
    required this.studentId,
    required this.email,
    required this.avatarUrl,
    required this.program,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      studentId: json['student_id'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      program: json['program'] ?? '',
      role: json['role'] ?? 'student',
    );
  }
}

class Course {
  final String id;
  final String title;
  final String code;
  final String instructor;
  final String instructorEmail;
  final String category;
  final Color categoryColor;
  final String imageUrl;
  final double progress;
  final int completedModules;
  final int totalModules;
  final String description;
  final List<Module> modules;
  final List<Assignment> assignments;
  final String semester;
  final double credits;
  final String? grade;
  final bool isActive;
  final List<String>? students;

  Course({
    required this.id,
    required this.title,
    required this.code,
    required this.instructor,
    required this.instructorEmail,
    required this.category,
    required this.categoryColor,
    required this.imageUrl,
    required this.progress,
    required this.completedModules,
    required this.totalModules,
    required this.description,
    required this.modules,
    required this.assignments,
    required this.semester,
    required this.credits,
    this.grade,
    this.isActive = true,
    this.students,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    // Basic hex color parser
    Color colorFromHex(String hexColor) {
      hexColor = hexColor.toUpperCase().replaceAll("#", "");
      if (hexColor.length == 6) hexColor = "FF" + hexColor;
      return Color(int.tryParse(hexColor, radix: 16) ?? 0xFF4DA3B6);
    }

    // Map modules and assignments
    var modulesData = json['modules'] as List<dynamic>? ?? [];
    List<Module> parsedModules = modulesData.map((e) => Module.fromJson(e)).toList();

    var assignmentsData = json['assignments'] as List<dynamic>? ?? [];
    List<Assignment> parsedAssignments = assignmentsData.map((e) => Assignment.fromJson(e)).toList();

    return Course(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      code: json['code'] ?? '',
      instructor: json['instructor'] ?? 'Unknown Instructor',
      instructorEmail: json['instructor_email'] ?? '',
      category: json['category'] ?? 'General',
      categoryColor: colorFromHex(json['category_color'] ?? '#4DA3B6'),
      imageUrl: json['image_url'] ?? '',
      progress: 0.0, // calculated later or provided via enrollments
      completedModules: 0,
      totalModules: parsedModules.length,
      description: json['description'] ?? '',
      modules: parsedModules,
      assignments: parsedAssignments,
      semester: json['semester'] ?? '',
      credits: (json['credits'] ?? 3.0).toDouble(),
      isActive: json['is_active'] ?? true,
      students: [], 
    );
  }

  String get statusText {
    if (progress >= 1.0) return "Completed";
    if (progress > 0) return "In Progress";
    return "Not Started";
  }
}

class Module {
  final String id;
  final String title;
  final String description;
  final bool isActive;
  final bool isCompleted;
  final bool isLocked;
  final int order;
  final List<Lesson> lessons;

  Module({
    required this.id,
    required this.title,
    required this.description,
    this.isActive = false,
    this.isCompleted = false,
    this.isLocked = false,
    required this.order,
    required this.lessons,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    var lessonsData = json['lessons'] as List<dynamic>? ?? [];
    List<Lesson> parsedLessons = lessonsData.map((e) => Lesson.fromJson(e)).toList();

    return Module(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      order: json['order_no'] ?? 0,
      isActive: json['is_active'] ?? true,
      isLocked: json['is_locked'] ?? false,
      lessons: parsedLessons,
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final String content;
  final String? videoUrl;
  final bool isActive;
  final bool isCompleted;
  final int order;
  final int durationMinutes;
  final List<ResourceFile> resources;
  final List<String> learningObjectives;

  Lesson({
    required this.id,
    required this.title,
    required this.content,
    this.videoUrl,
    this.isActive = false,
    this.isCompleted = false,
    required this.order,
    required this.durationMinutes,
    required this.resources,
    required this.learningObjectives,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    var resourcesData = json['resources'] as List<dynamic>? ?? [];
    List<ResourceFile> parsedResources = resourcesData.map((e) => ResourceFile.fromJson(e)).toList();

    var learningData = json['learning_objectives'] as List<dynamic>? ?? [];
    List<String> parsedObjectives = learningData.map((e) => e['objective'].toString()).toList();

    return Lesson(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      videoUrl: json['video_url'],
      isActive: json['is_active'] ?? true,
      order: json['order_no'] ?? 0,
      durationMinutes: json['duration_minutes'] ?? 0,
      resources: parsedResources,
      learningObjectives: parsedObjectives,
    );
  }
}

class ResourceFile {
  final String id;
  final String title;
  final String url;
  final String fileType;
  final String fileSize;
  final IconData icon;
  final Color iconColor;

  ResourceFile({
    required this.id,
    required this.title,
    required this.url,
    required this.fileType,
    required this.fileSize,
    required this.icon,
    required this.iconColor,
  });

  factory ResourceFile.fromJson(Map<String, dynamic> json) {
    return ResourceFile(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      fileType: json['file_type'] ?? 'Unknown',
      fileSize: json['file_size'] ?? '0 KB',
      icon: Icons.insert_drive_file,
      iconColor: Colors.blueGrey,
    );
  }
}

class Assignment {
  bool? isSubmitted;
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final double totalPoints;
  final String? submissionStatus;
  final DateTime? submittedAt;
  final double? earnedPoints;
  final String? feedback;
  final List<String> acceptedFormats;
  final double maxFileSizeMB;
  final String courseId;
  final String moduleId;
  String? lessonId;

  Assignment({
    required this.isSubmitted,
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.totalPoints,
    this.submissionStatus,
    this.submittedAt,
    this.earnedPoints,
    this.feedback,
    required this.acceptedFormats,
    required this.maxFileSizeMB,
    required this.courseId,
    required this.moduleId,
    this.lessonId,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    List<String> parsedFormats = [];
    if (json['accepted_formats'] != null) {
      parsedFormats = List<String>.from(json['accepted_formats']);
    }

    return Assignment(
      isSubmitted: false, // Calculated later from assignment_submissions
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : DateTime.now(),
      totalPoints: (json['total_points'] ?? 0).toDouble(),
      acceptedFormats: parsedFormats,
      maxFileSizeMB: (json['max_file_size_mb'] ?? 10.0).toDouble(),
      courseId: json['course_id'] ?? '',
      moduleId: json['module_id'] ?? '',
      lessonId: json['lesson_id'],
    );
  }

  bool get isOverdue =>
      DateTime.now().isAfter(dueDate) && (submissionStatus != 'submitted');

  bool get isActuallySubmitted => submissionStatus == 'submitted';

  String get daysUntilDue {
    final diff = dueDate.difference(DateTime.now()).inDays;
    if (diff < 0) return "Overdue";
    if (diff == 0) return "Due today";
    if (diff == 1) return "Due tomorrow";
    return "Due in $diff days";
  }
}

class ScheduleEvent {
  final String id;
  final String title;
  final String subtitle;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String courseId;
  final bool isPrimary;

  ScheduleEvent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.courseId,
    this.isPrimary = false,
  });

  factory ScheduleEvent.fromJson(Map<String, dynamic> json) {
    return ScheduleEvent(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      startTime: DateTime.parse(json['start_time'] ?? DateTime.now().toIso8601String()),
      endTime: DateTime.parse(json['end_time'] ?? DateTime.now().toIso8601String()),
      location: json['location'] ?? '',
      courseId: json['course_id'] ?? '',
      isPrimary: json['is_primary'] ?? false,
    );
  }

  String get timeRange =>
      "${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} ${startTime.hour >= 12 ? 'PM' : 'AM'} - ${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')} ${endTime.hour >= 12 ? 'PM' : 'AM'}";
}

class Deadline {
  final String id;
  final String title;
  final String subtitle;
  final DateTime dueDate;
  final Color color;
  final IconData icon;
  final String courseId;
  final String type; // 'assignment', 'quiz', 'project'

  Deadline({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.dueDate,
    required this.color,
    required this.icon,
    required this.courseId,
    required this.type,
  });

  factory Deadline.fromJson(Map<String, dynamic> json) {
    return Deadline(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      dueDate: DateTime.parse(json['due_date'] ?? DateTime.now().toIso8601String()),
      color: Colors.red,
      icon: Icons.assignment,
      courseId: json['course_id'] ?? '',
      type: json['type'] ?? 'assignment',
    );
  }
}

class Grade {
  final String courseId;
  final String courseCode;
  final String courseName;
  final String semester;
  final double credits;
  final String letterGrade;
  final double? numericGrade;
  final bool isPassed;
  final bool isInProgress;

  Grade({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.semester,
    required this.credits,
    required this.letterGrade,
    this.numericGrade,
    required this.isPassed,
    this.isInProgress = false,
  });
}

class Announcement {
  final String id;
  final String title;
  final String message;
  final DateTime postedDate;
  final String? link;
  final bool isPinned;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.postedDate,
    this.link,
    this.isPinned = false,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      postedDate: DateTime.parse(json['posted_date'] ?? DateTime.now().toIso8601String()),
      link: json['link'],
      isPinned: json['is_pinned'] ?? false,
    );
  }
}
