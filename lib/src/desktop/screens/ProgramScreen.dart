import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/LMS%20models/lms_models.dart';
import 'package:mac_app/src/desktop/components/Header.dart';
import 'package:mac_app/src/desktop/data/mockData.dart';
import 'package:mac_app/src/desktop/sub-screens/main/SubLayout.dart';

class ProgramScreen extends StatefulWidget {
  const ProgramScreen({Key? key}) : super(key: key);

  @override
  State<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  String selectedFilter = 'all';
  String sortBy = 'recent';

  @override
  Widget build(BuildContext context) {
    final filteredCourses = _getFilteredCourses();
    final sortedCourses = _getSortedCourses(filteredCourses);

    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
      child: Column(
        children: [
          Header(title: "My Courses"),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterBar(),
                    const SizedBox(height: 24),
                    _buildCourseGrid(sortedCourses),
                    const SizedBox(height: 32),
                    _buildLearningStats(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Course> _getFilteredCourses() {
    switch (selectedFilter) {
      case 'inProgress':
        return MockData.courses
            .where((c) => c.progress > 0 && c.progress < 1.0)
            .toList();
      case 'completed':
        return MockData.courses.where((c) => c.progress >= 1.0).toList();
      case 'upcoming':
        return MockData.courses.where((c) => c.progress == 0).toList();
      default:
        return MockData.courses;
    }
  }

  List<Course> _getSortedCourses(List<Course> courses) {
    final sorted = List<Course>.from(courses);
    switch (sortBy) {
      case 'alphabetical':
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'completion':
        sorted.sort((a, b) => b.progress.compareTo(a.progress));
        break;
      case 'recent':
      default:
        break;
    }
    return sorted;
  }

  Widget _buildFilterBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 768;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: isWide ? WrapAlignment.spaceBetween : WrapAlignment.start,
          children: [
            _buildFilterButtons(),
            if (isWide) _buildSortDropdown(),
          ],
        );
      },
    );
  }

  Widget _buildFilterButtons() {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FilterButton(
            label: "All",
            isSelected: selectedFilter == 'all',
            count: MockData.courses.length,
            onTap: () => setState(() => selectedFilter = 'all'),
          ),
          const SizedBox(width: 4),
          _FilterButton(
            label: "In Progress",
            isSelected: selectedFilter == 'inProgress',
            count: MockData.courses
                .where((c) => c.progress > 0 && c.progress < 1.0)
                .length,
            onTap: () => setState(() => selectedFilter = 'inProgress'),
          ),
          const SizedBox(width: 4),
          _FilterButton(
            label: "Completed",
            isSelected: selectedFilter == 'completed',
            count: MockData.courses.where((c) => c.progress >= 1.0).length,
            onTap: () => setState(() => selectedFilter = 'completed'),
          ),
          const SizedBox(width: 4),
          _FilterButton(
            label: "Upcoming",
            isSelected: selectedFilter == 'upcoming',
            count: MockData.courses.where((c) => c.progress == 0).length,
            onTap: () => setState(() => selectedFilter = 'upcoming'),
          ),
        ],
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Sort by:",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButton<String>(
            value: sortBy,
            underline: const SizedBox(),
            isDense: true,
            style: const TextStyle(
              color: Color(0xFF4DA3B6),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            items: const [
              DropdownMenuItem(
                value: "recent",
                child: Text("Recently Accessed"),
              ),
              DropdownMenuItem(
                value: "alphabetical",
                child: Text("Alphabetical"),
              ),
              DropdownMenuItem(
                value: "completion",
                child: Text("Completion %"),
              ),
            ],
            onChanged: (value) => setState(() => sortBy = value!),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseGrid(List<Course> courses) {
    if (courses.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 768) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 540,
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.75,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: courses.length,
          itemBuilder: (context, index) => _CourseCard(course: courses[index]),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            "No courses found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your filters",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningStats() {
    final totalCourses = MockData.courses.length;
    final inProgressCourses = MockData.courses
        .where((c) => c.progress > 0 && c.progress < 1.0)
        .length;
    final completedCourses = MockData.courses
        .where((c) => c.progress >= 1.0)
        .length;
    final totalAssignments = MockData.courses.fold<int>(
      0,
      (sum, c) => sum + c.assignments.length,
    );
    final dueAssignments = MockData.courses
        .expand((c) => c.assignments)
        .where((a) => (a.isSubmitted != true) && (a.isOverdue != true))
        .length;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4DA3B6).withOpacity(0.1),
            const Color(0xFF76b081).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4DA3B6).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.analytics, color: Color(0xFF4DA3B6), size: 28),
              SizedBox(width: 12),
              Text(
                "Your Learning Journey",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 768) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatCard(
                      icon: Icons.school,
                      label: "Total Courses",
                      value: totalCourses.toString(),
                      color: const Color(0xFF4DA3B6),
                    ),
                    _StatCard(
                      icon: Icons.trending_up,
                      label: "In Progress",
                      value: inProgressCourses.toString(),
                      color: Colors.orange,
                    ),
                    _StatCard(
                      icon: Icons.check_circle,
                      label: "Completed",
                      value: completedCourses.toString(),
                      color: Colors.green,
                    ),
                    _StatCard(
                      icon: Icons.assignment,
                      label: "Total Assignments",
                      value: totalAssignments.toString(),
                      color: Colors.purple,
                    ),
                    _StatCard(
                      icon: Icons.schedule,
                      label: "Due Soon",
                      value: dueAssignments.toString(),
                      color: Colors.red,
                    ),
                  ],
                );
              } else {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _StatCard(
                      icon: Icons.school,
                      label: "Total Courses",
                      value: totalCourses.toString(),
                      color: const Color(0xFF4DA3B6),
                    ),
                    _StatCard(
                      icon: Icons.trending_up,
                      label: "In Progress",
                      value: inProgressCourses.toString(),
                      color: Colors.orange,
                    ),
                    _StatCard(
                      icon: Icons.check_circle,
                      label: "Completed",
                      value: completedCourses.toString(),
                      color: Colors.green,
                    ),
                    _StatCard(
                      icon: Icons.assignment,
                      label: "Total Assignments",
                      value: totalAssignments.toString(),
                      color: Colors.purple,
                    ),
                    _StatCard(
                      icon: Icons.schedule,
                      label: "Due Soon",
                      value: dueAssignments.toString(),
                      color: Colors.red,
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final int count;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.black87 : Colors.grey.shade600,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4DA3B6).withOpacity(0.2)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? const Color(0xFF4DA3B6)
                        : Colors.grey.shade600,
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
        .where((a) =>
            (a.isSubmitted != true) &&
            (a.isOverdue != true))
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
                        widget.course.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: Icon(
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
              Expanded(
                child: Padding(
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
                      const Spacer(),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}