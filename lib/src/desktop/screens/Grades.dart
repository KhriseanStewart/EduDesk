// lib/src/screens/GradesScreen.dart

import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/LMS%20models/lms_models.dart';
import 'package:mac_app/src/desktop/data/mockData.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final grades = MockData.grades;
    final completedGrades = grades.where((g) => g.isPassed).toList();
    final totalCredits = completedGrades.fold<double>(0, (sum, g) => sum + g.credits);
    final gpa = _calculateGPA(completedGrades);

    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsCards(gpa, totalCredits, completedGrades.length, grades.length),
                  const SizedBox(height: 24),
                  _buildGradesTable(grades),
                  const SizedBox(height: 24),
                  _buildPerformanceChart(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          const Text(
            "Grades & Transcript",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download),
            label: const Text("Download Transcript"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4DA3B6),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(double gpa, double credits, int passed, int total) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 2,
      children: [
        _StatCard(
          title: "Cumulative GPA",
          value: gpa.toStringAsFixed(2),
          subtitle: "Out of 4.0",
          color: const Color(0xFF4DA3B6),
        ),
        _StatCard(
          title: "Credits Earned",
          value: credits.toStringAsFixed(1),
          subtitle: "${(credits / 60 * 100).toInt()}% of program",
          color: Colors.green,
        ),
        _StatCard(
          title: "Courses Passed",
          value: "$passed / $total",
          subtitle: "Total courses",
          color: Colors.orange,
        ),
        _StatCard(
          title: "Current Term",
          value: "Fall 2024",
          subtitle: "Active semester",
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildGradesTable(List<Grade> grades) {
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
                Expanded(flex: 1, child: _TableHeader("CODE")),
                Expanded(flex: 3, child: _TableHeader("COURSE NAME")),
                Expanded(flex: 2, child: _TableHeader("SEMESTER")),
                Expanded(flex: 1, child: _TableHeader("CREDITS")),
                Expanded(flex: 1, child: _TableHeader("GRADE")),
                Expanded(flex: 2, child: _TableHeader("STATUS")),
              ],
            ),
          ),
          ...grades.map((grade) => _GradeRow(grade)),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
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
          const Text(
            "Performance Over Time",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Center(
              child: Text(
                "Chart visualization would go here",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateGPA(List<Grade> grades) {
    if (grades.isEmpty) return 0.0;
    
    double totalPoints = 0;
    double totalCredits = 0;
    
    for (var grade in grades) {
      if (grade.numericGrade != null) {
        final gradePoint = _gradeToPoint(grade.letterGrade);
        totalPoints += gradePoint * grade.credits;
        totalCredits += grade.credits;
      }
    }
    
    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  double _gradeToPoint(String letter) {
    switch (letter) {
      case 'A': return 4.0;
      case 'A-': return 3.7;
      case 'B+': return 3.3;
      case 'B': return 3.0;
      case 'B-': return 2.7;
      case 'C+': return 2.3;
      case 'C': return 2.0;
      default: return 0.0;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
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

class _GradeRow extends StatelessWidget {
  final Grade grade;
  const _GradeRow(this.grade);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              grade.courseCode,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF4DA3B6),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              grade.courseName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(grade.semester),
          ),
          Expanded(
            flex: 1,
            child: Text(grade.credits.toString()),
          ),
          Expanded(
            flex: 1,
            child: Text(
              grade.letterGrade,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: _StatusChip(
              isPassed: grade.isPassed,
              isInProgress: grade.isInProgress,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isPassed;
  final bool isInProgress;

  const _StatusChip({
    required this.isPassed,
    required this.isInProgress,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPassed
        ? Colors.green
        : isInProgress
        ? Colors.orange
        : Colors.red;
    
    final label = isPassed
        ? "PASSED"
        : isInProgress
        ? "IN PROGRESS"
        : "NOT PASSED";

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
        textAlign: TextAlign.center,
      ),
    );
  }
}