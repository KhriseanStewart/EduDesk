import 'package:flutter/material.dart';
import 'package:mac_app/src/components/Header.dart';
import 'package:mac_app/src/sub-screens/main/SubLayout.dart';
import 'package:mac_app/src/sub-screens/screen/CourseDetails.dart';

class ProgramScreen extends StatefulWidget {
  const ProgramScreen({Key? key}) : super(key: key);

  @override
  State<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  String selectedFilter = 'inProgress';
  String sortBy = 'recent';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
      child: Column(
        children: [
          Header(title: "My Courses"),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Column(
                  children: [
                    _buildFilterBar(),
                    const SizedBox(height: 32),
                    _buildCourseGrid(),
                    const SizedBox(height: 48),
                    _buildLearningStatsBanner(),
                    const SizedBox(height: 40),
                    // _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _FilterButton(
                label: "In Progress",
                isSelected: selectedFilter == 'inProgress',
                onTap: () => setState(() => selectedFilter = 'inProgress'),
              ),
              const SizedBox(width: 8),
              _FilterButton(
                label: "Completed",
                isSelected: selectedFilter == 'completed',
                onTap: () => setState(() => selectedFilter = 'completed'),
              ),
              const SizedBox(width: 8),
              _FilterButton(
                label: "Upcoming",
                isSelected: selectedFilter == 'upcoming',
                onTap: () => setState(() => selectedFilter = 'upcoming'),
              ),
            ],
          ),
        ),
        Row(
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
            DropdownButton<String>(
              value: sortBy,
              underline: const SizedBox(),
              style: const TextStyle(
                color: Color(0xFF3cc2dd),
                fontWeight: FontWeight.bold,
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
              onChanged: (value) {
                setState(() => sortBy = value!);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCourseGrid() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 32,
      mainAxisSpacing: 32,
      childAspectRatio: 0.85,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _CourseCard(
          title: "Computer Essentials",
          instructor: "Mr. Thompson",
          progress: 0.6,
          completedModules: 12,
          totalModules: 20,
          category: "Technical",
          categoryColor: Color(0xFF3cc2dd),
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAxA53z9aB7WISrDl1etMSRHMKvfGTGpWvMU75TooTn8T0eDofUEfU3irNggxX6u5-4w5h0TANKKjDHQBxMn0rLe5sj8EchvPRzVCSE2XByp0fkGVs31WC6ZsH4pnrXeMMjI5lMxx2cJcix0t5P6u9EhlUnTl6Ss7hs7U-Aoq0V0z8LcaImmPr62TIlwG4QFCPmLtfo8pQ-Cn3XQTxez7f_hgVbMn1xfthPBZ8tonVVqJgHVnjn6rENTAbed7r_DKT387SpU9tPHOY',
        ),
        _CourseCard(
          title: "Customer Service Excellence",
          instructor: "Ms. Gordon",
          progress: 0.25,
          completedModules: 4,
          totalModules: 16,
          category: "Soft Skills",
          categoryColor: Color(0xFF76b081),
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDR4YDtwlmPYinoxLqV_8H0jiaOQO9R6O_hSY7PrvynhmMNpj3MZCBIKeNPLcX833NwSr3Nu9XRLApm5FWGW3dGBMMAnvKOAnjRuCFvAXQLR5TjTLNzYDyRh1quqzYF8S8QX9RoMGU90GLEn7qoHB1DeqlZfstcXRNxOuJSCOUEsXaNybrOQZ3KjUCabOP3F3VY4dvvuE-oUyz7siXDb_jSTVUJlBu7178TlsfeVeU9YbgCBzkn1rVchQQXKTVDuDX9Rpd0Z-Lv42M',
        ),
        _CourseCard(
          title: "Occupational Health & Safety",
          instructor: "Dr. Richards",
          progress: 0.05,
          completedModules: 1,
          totalModules: 18,
          category: "Compliance",
          categoryColor: Color(0xFFc0a07a),
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCU6-r-s4caYwAm4-IOLsw48Q_7Ze80PmdwKNDSb1rLFk0T5iWP62-KspESuOiFS7151Y7rxLOd___zIhDM76F1Ie407YdQc8fGGHl1ECqHbKVzivAFMA3Zs9AkhwjdjCHxISmj9MZK7mK3mEj55R1my8rr0dLmxedskUIQpXPAJhWRVfKxpKpIzOvUjcBuwcu-TjTj6jORYsNPwXeDfRkatzfwxJH-tX84QDAnMvUeSM5HEQIp9Rjd0vZbJlbKDFZ9AYE1q3q46Sg',
        ),
      ],
    );
  }

  Widget _buildLearningStatsBanner() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF3cc2dd).withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3cc2dd).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.trending_up,
              color: Color(0xFF3cc2dd),
              size: 40,
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Weekly Learning Progress",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "You've completed 5 modules this week. Keep going to reach your goal of 10!",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Row(
            children: [
              _StatItem(label: "Hours Spent", value: "14.5"),
              Container(
                width: 1,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: const Color(0xFF3cc2dd).withOpacity(0.2),
              ),
              _StatItem(label: "Badges Earned", value: "03"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "© 2024 HEART NSTA LMS. All rights reserved.",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          Row(
            children: [
              _FooterLink(label: "Privacy Policy"),
              const SizedBox(width: 24),
              _FooterLink(label: "Help Center"),
              const SizedBox(width: 24),
              _FooterLink(label: "System Status"),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.black87 : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

class _CourseCard extends StatefulWidget {
  final String title;
  final String instructor;
  final double progress;
  final int completedModules;
  final int totalModules;
  final String category;
  final Color categoryColor;
  final String imageUrl;

  const _CourseCard({
    required this.title,
    required this.instructor,
    required this.progress,
    required this.completedModules,
    required this.totalModules,
    required this.category,
    required this.categoryColor,
    required this.imageUrl,
  });

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => Sublayout()));
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, isHovered ? -4 : 0, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isHovered ? 0.15 : 0.05),
                blurRadius: isHovered ? 30 : 20,
                offset: Offset(0, isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with category badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image_not_supported_outlined, size: 100),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.category.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: widget.categoryColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isHovered
                              ? const Color(0xFF3cc2dd)
                              : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.instructor,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Progress section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${(widget.progress * 100).toInt()}% Complete",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "${widget.completedModules}/${widget.totalModules} Modules",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: widget.progress,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF3cc2dd),
                          ),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3cc2dd),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Resume Learning",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.play_circle, size: 18),
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

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;

  const _FooterLink({required this.label});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () {},
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            color: isHovered ? const Color(0xFF3cc2dd) : Colors.grey.shade600,
            decoration: isHovered ? TextDecoration.underline : null,
          ),
        ),
      ),
    );
  }
}
