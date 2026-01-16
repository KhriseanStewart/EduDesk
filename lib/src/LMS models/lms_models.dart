// lib/src/models/course_data.dart

import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String studentId;
  final String email;
  final String avatarUrl;
  final String program;

  User({
    required this.id,
    required this.name,
    required this.studentId,
    required this.email,
    required this.avatarUrl,
    required this.program,
  });
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
  });

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
}

class Assignment {
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
  final String lessonId;

  Assignment({
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
    required this.lessonId
  });

  bool get isOverdue =>
      DateTime.now().isAfter(dueDate) && submissionStatus != 'submitted';
  bool get isSubmitted => submissionStatus == 'submitted';

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
}
