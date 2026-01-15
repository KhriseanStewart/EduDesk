import 'package:flutter/material.dart';
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
  int currentindex = 0;
  @override
  Widget build(BuildContext context) {
    print(currentindex);
    return Scaffold(
      body: Row(
        children: [
          SizedBox(width: 320, child: _buildSidebar()),

          /// MAIN CONTENT AREA
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(index: currentindex),

                /// This MUST be Expanded or you’ll get overflow
                currentindex == 0
                    ? Expanded(child: CourseDetailsScreen())
                    : currentindex == 1
                    ? Expanded(child: AssignmentSubmissionScreen())
                    : Expanded(child: GradesTranscriptScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader({required int index}) {
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
              color: const Color(0xFF289F91),
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
          // Navigation
          TextButton(
            onPressed: () {
              setState(() {
                currentindex = 0;
              });
            },
            child: Text(
              'My Courses',
              style: TextStyle(
                color: currentindex == 0
                    ? Color(0xFF289F91)
                    : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () {
              setState(() {
                currentindex = 1;
              });
            },
            child: Text(
              'Assignments',
              style: TextStyle(
                color: currentindex == 1
                    ? Color(0xFF289F91)
                    : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () {
              setState(() {
                currentindex = 2;
              });
            },
            child: Text(
              'Grades',
              style: TextStyle(
                color: currentindex == 2
                    ? Color(0xFF289F91)
                    : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          const Spacer(),
          // Search Bar
          Container(
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
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                  color: Colors.grey.shade400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // User Profile
          Container(
            padding: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Andrew Thompson',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'STUDENT ID: 88421',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF289F91).withOpacity(0.2),
                      width: 2,
                    ),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDOV9ZqEQXNpGPLpvaModLNGhGuypdjyD8uxABTHjhUbSpFQxpgwOCH6Nyxzb3YW3H6dt4bzrV_2TShSbjrhGxv7OrL5IwewJCmtxcAe3PyVmDdauHJ0dxu5xevmY-8CbzBGkFgU6s7ryAPAdYSoYiI9JNW6VRKoRfs6MJ7UHaFNKOxmAC_miNprTdH51W3G_zwPeIvnuIKFk9i_Eft3N9r3pugXW6j2vhETNwRuXJi4FkCKqP5Z__uxZRBcIv_Q8PeGSRXP1-YP4w',
                      ),
                      fit: BoxFit.cover,
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

  Widget _buildSidebar() {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: const Color(0xFFE9F1F0))),
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
                    // Progress Bar
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Course Progress',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
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
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF289F91),
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Module 1: Completed
                    _ModuleSection(
                      title: "Module 1: Hardware",
                      isCompleted: true,
                      lessons: const [
                        _LessonItem(
                          title: "1.1 What is a Computer?",
                          isCompleted: true,
                        ),
                        _LessonItem(
                          title: "1.2 Input & Output Devices",
                          isCompleted: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Module 2: Active
                    _ModuleSection(
                      title: "Module 2: Software",
                      isActive: true,
                      lessons: const [
                        _LessonItem(
                          title: "2.1 System Software",
                          isActive: true,
                        ),
                        _LessonItem(title: "2.2 Application Suites"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Module 3: Locked
                    _ModuleSection(
                      title: "Module 3: Safety",
                      isLocked: true,
                      lessons: const [],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Button
          Row(
            spacing: 0,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFE9F1F0))),
                ),
                child: OutlinedButton.icon(
                  label: Text("Go back"),
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => MainLayout()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey,
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
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
          ),
        ],
      ),
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
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? const Color(0xFF289F91)
                      : Colors.grey.shade400,
                  letterSpacing: 1.2,
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

  const _LessonItem({
    required this.title,
    this.isCompleted = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF289F91).withOpacity(0.1) : null,
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
                color: isActive
                    ? const Color(0xFF289F91)
                    : isCompleted
                    ? Colors.grey.shade500
                    : Colors.black87,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
