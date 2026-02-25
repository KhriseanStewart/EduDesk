import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/LMS models/lms_models.dart';
import 'package:mac_app/src/services/supabase_service.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  final SupabaseService _supabase = SupabaseService();
  late Future<List<Grade>> _gradesFuture;

  @override
  void initState() {
    super.initState();
    _gradesFuture = _supabase.getGrades();
  }

  double _calculateGPA(List<Grade> grades) {
    if (grades.isEmpty) return 0.0;
    double totalPoints = 0, totalCredits = 0;
    for (var g in grades) {
      if (g.numericGrade != null || (g.letterGrade != '--' && g.letterGrade.isNotEmpty)) {
        totalPoints += _gradeToPoint(g.letterGrade) * g.credits;
        totalCredits += g.credits;
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

  void _refresh() {
    setState(() => _gradesFuture = _supabase.getGrades());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grades', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F181A),
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded, size: 20),
            label: const Text('Download'),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF4DA3B6)),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Grade>>(
          future: _gradesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: _refresh, child: const Text('Retry')),
                    ],
                  ),
                ),
              );
            }
            final grades = snapshot.data ?? [];
            final completed = grades.where((g) => g.isPassed).toList();
            final credits = completed.fold<double>(0, (s, g) => s + g.credits);
            final gpa = _calculateGPA(completed);

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'My Grades',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _StatRow(label: 'GPA', value: gpa.toStringAsFixed(2), color: const Color(0xFF4DA3B6)),
                      const SizedBox(height: 12),
                      _StatRow(label: 'Credits', value: credits.toStringAsFixed(1), color: Colors.green),
                      const SizedBox(height: 12),
                      _StatRow(label: 'Passed', value: '${completed.length} / ${grades.length}', color: Colors.orange),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              if (grades.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No grades to display.')),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final g = grades[index];
                      return _GradeCard(grade: g);
                    },
                    childCount: grades.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatRow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, color: Colors.grey.shade700)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _GradeCard extends StatelessWidget {
  final Grade grade;

  const _GradeCard({required this.grade});

  @override
  Widget build(BuildContext context) {
    final statusColor = grade.isPassed ? Colors.green : (grade.isInProgress ? Colors.orange : Colors.red);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(grade.courseName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${grade.courseCode} · ${grade.semester} · ${grade.credits} cr'),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(grade.letterGrade, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                grade.isPassed ? 'Passed' : (grade.isInProgress ? 'In progress' : 'Not passed'),
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
