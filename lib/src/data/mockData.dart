// lib/src/data/mock_data.dart

import 'package:flutter/material.dart';
import 'package:mac_app/src/LMS%20models/lms_models.dart';

class MockData {
  static final User currentUser = User(
    id: "u001",
    name: "Khrisean Stewart",
    studentId: "111-111-111",
    email: "khrisean.stewart@heart.edu.jm",
    avatarUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuDOV9ZqEQXNpGPLpvaModLNGhGuypdjyD8uxABTHjhUbSpFQxpgwOCH6Nyxzb3YW3H6dt4bzrV_2TShSbjrhGxv7OrL5IwewJCmtxcAe3PyVmDdauHJ0dxu5xevmY-8CbzBGkFgU6s7ryAPAdYSoYiI9JNW6VRKoRfs6MJ7UHaFNKOxmAC_miNprTdH51W3G_zwPeIvnuIKFk9i_Eft3N9r3pugXW6j2vhETNwRuXJi4FkCKqP5Z__uxZRBcIv_Q8PeGSRXP1-YP4w",
    program: "ICT-2024 Program",
  );

   static final List<Course> courses = [
    Course(
      id: "c001",
      title: "Introduction to ICT",
      code: "ICT101",
      instructor: "Dr. Thompson",
      instructorEmail: "thompson@heart.edu.jm",
      category: "Technical",
      categoryColor: const Color(0xFF4DA3B6),
      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuAxA53z9aB7WISrDl1etMSRHMKvfGTGpWvMU75TooTn8T0eDofUEfU3irNggxX6u5-4w5h0TANKKjDHQBxMn0rLe5sj8EchvPRzVCSE2XByp0fkGVs31WC6ZsH4pnrXeMMjI5lMxx2cJcix0t5P6u9EhlUnTl6Ss7hs7U-Aoq0V0z8LcaImmPr62TIlwG4QFCPmLtfo8pQ-Cn3XQTxez7f_hgVbMn1xfthPBZ8tonVVqJgHVnjn6rENTAbed7r_DKT387SpU9tPHOY",
      progress: 0.75,
      completedModules: 3,
      totalModules: 4,
      description: "Comprehensive introduction to Information and Communications Technology, covering hardware, software, networking, and digital literacy.",
      modules: [
        // MODULE 1: Computer Hardware
        Module(
          id: "m001",
          title: "Module 1: Computer Hardware",
          description: "Understanding computer components and architecture",
          isCompleted: true,
          order: 1,
          lessons: [
            Lesson(
              id: "l001",
              title: "1.1 System Components",
              content: "Learn about the fundamental components of a computer system including CPU, RAM, storage devices, and peripherals.",
              videoUrl: "https://us02web.zoom.us/rec/share/QGd3bi-YIAwwAp8UI3vtG9rLDA4Z1EU2MN23mSqcwTVv3FiVHeLWZ7Qrkr7mJI6e.1dnyaNamkLNyD-_p",
              isCompleted: true,
              order: 1,
              durationMinutes: 45,
              resources: [
                ResourceFile(
                  id: "r001",
                  title: "Hardware_Basics.pdf",
                  url: "/downloads/hardware_basics.pdf",
                  fileType: "PDF",
                  fileSize: "2.3 MB",
                  icon: Icons.picture_as_pdf,
                  iconColor: Colors.red,
                ),
                ResourceFile(
                  id: "r002",
                  title: "CPU_Architecture.pdf",
                  url: "/downloads/cpu_architecture.pdf",
                  fileType: "PDF",
                  fileSize: "1.8 MB",
                  icon: Icons.picture_as_pdf,
                  iconColor: Colors.red,
                ),
              ],
              learningObjectives: [
                "Identify major computer components",
                "Understand the role of CPU and RAM",
                "Recognize different storage types",
                "Explain how components work together",
              ],
            ),
            Lesson(
              id: "l002",
              title: "1.2 Input/Output Devices",
              content: "Explore various input and output devices and their functions in a computer system.",
              isCompleted: true,
              order: 2,
              durationMinutes: 30,
              resources: [
                ResourceFile(
                  id: "r003",
                  title: "IO_Devices_Guide.pdf",
                  url: "/downloads/io_devices.pdf",
                  fileType: "PDF",
                  fileSize: "1.5 MB",
                  icon: Icons.picture_as_pdf,
                  iconColor: Colors.red,
                ),
              ],
              learningObjectives: [
                "Classify input and output devices",
                "Understand device drivers",
                "Identify peripheral connections",
              ],
            ),
            Lesson(
              id: "l003",
              title: "1.3 Storage Technologies",
              content: "Deep dive into storage technologies including HDD, SSD, and cloud storage solutions.",
              isCompleted: true,
              order: 3,
              durationMinutes: 40,
              resources: [
                ResourceFile(
                  id: "r004",
                  title: "Storage_Comparison.xlsx",
                  url: "/downloads/storage_comparison.xlsx",
                  fileType: "XLSX",
                  fileSize: "890 KB",
                  icon: Icons.table_chart,
                  iconColor: Colors.green,
                ),
              ],
              learningObjectives: [
                "Compare HDD vs SSD technologies",
                "Understand storage capacity measurements",
                "Evaluate cloud storage options",
              ],
            ),
          ],
        ),
        
        // MODULE 2: Software & Operating Systems
        Module(
          id: "m002",
          title: "Module 2: Software & Operating Systems",
          description: "Understanding system and application software",
          isActive: true,
          order: 2,
          lessons: [
            Lesson(
              id: "l004",
              title: "2.1 System Software",
              content: "System software is a type of computer program designed to run a computer's hardware and application programs. If we think of the computer system as a layered architecture, the system software is the interface between the hardware and user applications.",
              videoUrl: "https://us02web.zoom.us/rec/share/QGd3bi-YIAwwAp8UI3vtG9rLDA4Z1EU2MN23mSqcwTVv3FiVHeLWZ7Qrkr7mJI6e.1dnyaNamkLNyD-_p",
              isActive: true,
              order: 1,
              durationMinutes: 50,
              resources: [
                ResourceFile(
                  id: "r005",
                  title: "OS_Basics.pdf",
                  url: "/downloads/os_basics.pdf",
                  fileType: "PDF",
                  fileSize: "1.2 MB",
                  icon: Icons.picture_as_pdf,
                  iconColor: Colors.red,
                ),
                ResourceFile(
                  id: "r006",
                  title: "ICT_Terminologies.docx",
                  url: "/downloads/terminologies.docx",
                  fileType: "DOCX",
                  fileSize: "450 KB",
                  icon: Icons.description,
                  iconColor: Colors.blue,
                ),
              ],
              learningObjectives: [
                "Resource Management: Handling CPU, Memory, and Storage",
                "Process Management: Handling multiple tasks simultaneously",
                "Storage Management: File organization and disk access",
              ],
            ),
            Lesson(
              id: "l005",
              title: "2.2 Application Software",
              content: "Learn about different types of application software and their uses in various domains.",
              order: 2,
              durationMinutes: 40,
              resources: [
                ResourceFile(
                  id: "r007",
                  title: "Software_Categories.pdf",
                  url: "/downloads/software_categories.pdf",
                  fileType: "PDF",
                  fileSize: "2.1 MB",
                  icon: Icons.picture_as_pdf,
                  iconColor: Colors.red,
                ),
              ],
              learningObjectives: [
                "Identify application software categories",
                "Understand software licensing",
                "Evaluate software for specific tasks",
              ],
            ),
            Lesson(
              id: "l006",
              title: "2.3 Operating System Installation",
              content: "Hands-on guide to installing and configuring operating systems, including partitioning and dual-boot setups.",
              order: 3,
              durationMinutes: 60,
              resources: [
                ResourceFile(
                  id: "r008",
                  title: "OS_Installation_Guide.pdf",
                  url: "/downloads/os_installation.pdf",
                  fileType: "PDF",
                  fileSize: "3.2 MB",
                  icon: Icons.picture_as_pdf,
                  iconColor: Colors.red,
                ),
                ResourceFile(
                  id: "r009",
                  title: "Partitioning_Tutorial.mp4",
                  url: "/downloads/partitioning.mp4",
                  fileType: "MP4",
                  fileSize: "45 MB",
                  icon: Icons.video_library,
                  iconColor: Colors.purple,
                ),
              ],
              learningObjectives: [
                "Install an operating system",
                "Configure system partitions",
                "Set up dual-boot environments",
              ],
            ),
          ],
        ),
        
        // MODULE 3: Networking Fundamentals
        Module(
          id: "m003",
          title: "Module 3: Networking Fundamentals",
          description: "Introduction to computer networks and internet technologies",
          order: 3,
          lessons: [
            Lesson(
              id: "l007",
              title: "3.1 Network Types",
              content: "Explore different types of computer networks including LAN, WAN, and wireless networks.",
              order: 1,
              durationMinutes: 45,
              resources: [
                ResourceFile(
                  id: "r010",
                  title: "Network_Types.pdf",
                  url: "/downloads/network_types.pdf",
                  fileType: "PDF",
                  fileSize: "1.7 MB",
                  icon: Icons.picture_as_pdf,
                  iconColor: Colors.red,
                ),
              ],
              learningObjectives: [
                "Distinguish between network types",
                "Understand network topologies",
                "Identify network components",
              ],
            ),
            Lesson(
              id: "l008",
              title: "3.2 TCP/IP Protocol Suite",
              content: "Understanding the TCP/IP protocol stack and how data travels across networks.",
              order: 2,
              durationMinutes: 50,
              resources: [
                ResourceFile(
                  id: "r011",
                  title: "TCPIP_Model.pdf",
                  url: "/downloads/tcpip_model.pdf",
                  fileType: "PDF",
                  fileSize: "2.0 MB",
                  icon: Icons.picture_as_pdf,
                  iconColor: Colors.red,
                ),
                ResourceFile(
                  id: "r012",
                  title: "IP_Addressing.xlsx",
                  url: "/downloads/ip_addressing.xlsx",
                  fileType: "XLSX",
                  fileSize: "650 KB",
                  icon: Icons.table_chart,
                  iconColor: Colors.green,
                ),
              ],
              learningObjectives: [
                "Explain the TCP/IP model layers",
                "Understand IP addressing",
                "Configure basic network settings",
              ],
            ),
            Lesson(
              id: "l009",
              title: "3.3 Network Troubleshooting",
              content: "Learn essential network troubleshooting techniques and tools for diagnosing connectivity issues.",
              order: 3,
              durationMinutes: 55,
              resources: [
                ResourceFile(
                  id: "r013",
                  title: "Troubleshooting_Guide.pdf",
                  url: "/downloads/troubleshooting.pdf",
                  fileType: "PDF",
                  fileSize: "2.5 MB",
                  icon: Icons.picture_as_pdf,
                  iconColor: Colors.red,
                ),
                ResourceFile(
                  id: "r014",
                  title: "Network_Lab.pka",
                  url: "/downloads/network_lab.pka",
                  fileType: "PKA",
                  fileSize: "5.2 MB",
                  icon: Icons.router,
                  iconColor: Colors.orange,
                ),
              ],
              learningObjectives: [
                "Use ping and traceroute commands",
                "Diagnose common network issues",
                "Apply systematic troubleshooting methods",
              ],
            ),
          ],
        ),
        
        // MODULE 4: Digital Security
        Module(
          id: "m004",
          title: "Module 4: Digital Security",
          description: "Cybersecurity basics and best practices",
          isLocked: true,
          order: 4,
          lessons: [
            Lesson(
              id: "l010",
              title: "4.1 Security Threats",
              content: "Understanding common security threats and vulnerabilities in digital systems.",
              order: 1,
              durationMinutes: 50,
              resources: [
                ResourceFile(
                  id: "r015",
                  title: "Security_Threats.pdf",
                  url: "/downloads/security_threats.pdf",
                  fileType: "PDF",
                  fileSize: "2.8 MB",
                  icon: Icons.picture_as_pdf,
                  iconColor: Colors.red,
                ),
              ],
              learningObjectives: [
                "Identify common security threats",
                "Understand malware types",
                "Recognize phishing attempts",
              ],
            ),
            Lesson(
              id: "l011",
              title: "4.2 Encryption & Authentication",
              content: "Learn about encryption methods, password security, and multi-factor authentication.",
              order: 2,
              durationMinutes: 45,
              resources: [
                ResourceFile(
                  id: "r016",
                  title: "Encryption_Basics.pdf",
                  url: "/downloads/encryption.pdf",
                  fileType: "PDF",
                  fileSize: "1.9 MB",
                  icon: Icons.picture_as_pdf,
                  iconColor: Colors.red,
                ),
              ],
              learningObjectives: [
                "Explain encryption concepts",
                "Create strong passwords",
                "Implement multi-factor authentication",
              ],
            ),
            Lesson(
              id: "l012",
              title: "4.3 Security Best Practices",
              content: "Comprehensive guide to implementing security best practices in personal and professional contexts.",
              order: 3,
              durationMinutes: 40,
              resources: [
                ResourceFile(
                  id: "r017",
                  title: "Best_Practices_Checklist.pdf",
                  url: "/downloads/best_practices.pdf",
                  fileType: "PDF",
                  fileSize: "1.3 MB",
                  icon: Icons.picture_as_pdf,
                  iconColor: Colors.red,
                ),
              ],
              learningObjectives: [
                "Apply security best practices",
                "Conduct security audits",
                "Develop security policies",
              ],
            ),
          ],
        ),
      ],
      assignments: [
        // Module 1 Assignments
        Assignment(
          isSubmitted: true,
          id: "a001",
          title: "Hardware Components Quiz",
          description: "Complete the multiple-choice assessment on computer hardware components.",
          dueDate: DateTime.now().add(const Duration(days: 2)),
          totalPoints: 50,
          acceptedFormats: ["Online Quiz"],
          maxFileSizeMB: 0,
          courseId: "c001",
          moduleId: "m001",
          lessonId: "l001",
        ),
        Assignment(
          isSubmitted: true,
          id: "a002",
          title: "System Components Diagram",
          description: "Create a labeled diagram showing the major components of a computer system and how they interact.",
          dueDate: DateTime.now().add(const Duration(days: 3)),
          totalPoints: 30,
          acceptedFormats: [".pdf", ".png", ".jpg"],
          maxFileSizeMB: 5,
          courseId: "c001",
          moduleId: "m001",
          lessonId: "l001",
        ),
        Assignment(
          isSubmitted: true,
          id: "a003",
          title: "Input/Output Devices Report",
          description: "Write a brief report identifying and explaining 5 input devices and 5 output devices used in modern computing.",
          dueDate: DateTime.now().add(const Duration(days: 4)),
          totalPoints: 40,
          acceptedFormats: [".pdf", ".docx"],
          maxFileSizeMB: 10,
          courseId: "c001",
          moduleId: "m001",
          lessonId: "l002",
        ),
        Assignment(
          isSubmitted: true,
          id: "a004",
          title: "Storage Technology Comparison",
          description: "Compare HDD, SSD, and cloud storage technologies. Include advantages, disadvantages, and use cases.",
          dueDate: DateTime.now().add(const Duration(days: 5)),
          totalPoints: 35,
          acceptedFormats: [".pdf", ".docx"],
          maxFileSizeMB: 10,
          courseId: "c001",
          moduleId: "m001",
          lessonId: "l003",
        ),
        
        // Module 2 Assignments
        Assignment(
          isSubmitted: true,
          id: "a005",
          title: "Operating Systems Report",
          description: "Write a comprehensive report comparing three different operating systems (Windows, macOS, Linux).",
          dueDate: DateTime.now().add(const Duration(days: 1)),
          totalPoints: 75,
          acceptedFormats: [".pdf", ".docx"],
          maxFileSizeMB: 10,
          courseId: "c001",
          moduleId: "m002",
          lessonId: "l004",
        ),
        Assignment(
          isSubmitted: true,
          id: "a006",
          title: "System Software Functions Quiz",
          description: "Online quiz covering resource management, process management, and storage management.",
          dueDate: DateTime.now().add(const Duration(days: 2)),
          totalPoints: 45,
          acceptedFormats: ["Online Quiz"],
          maxFileSizeMB: 0,
          courseId: "c001",
          moduleId: "m002",
          lessonId: "l004",
        ),
        Assignment(
          isSubmitted: true,
          id: "a007",
          title: "Application Software Case Study",
          description: "Research and present a case study on a specific application software used in your field of interest.",
          dueDate: DateTime.now().add(const Duration(days: 6)),
          totalPoints: 60,
          acceptedFormats: [".pdf", ".pptx"],
          maxFileSizeMB: 15,
          courseId: "c001",
          moduleId: "m002",
          lessonId: "l005",
        ),
        Assignment(
          isSubmitted: true,
          id: "a008",
          title: "OS Installation Lab Report",
          description: "Document your process of installing an operating system in a virtual machine, including screenshots and troubleshooting steps.",
          dueDate: DateTime.now().add(const Duration(days: 8)),
          totalPoints: 80,
          acceptedFormats: [".pdf", ".docx"],
          maxFileSizeMB: 20,
          courseId: "c001",
          moduleId: "m002",
          lessonId: "l006",
        ),
        
        // Module 3 Assignments
        Assignment(
          isSubmitted: true,
          id: "a009",
          title: "Network Types Comparison",
          description: "Create a comparison chart of LAN, WAN, and wireless networks including advantages and use cases.",
          dueDate: DateTime.now().add(const Duration(days: 7)),
          totalPoints: 50,
          acceptedFormats: [".pdf", ".xlsx", ".docx"],
          maxFileSizeMB: 10,
          courseId: "c001",
          moduleId: "m003",
          lessonId: "l007",
        ),
        Assignment(
          isSubmitted: true,
          id: "a010",
          title: "TCP/IP Lab Exercise",
          description: "Complete the TCP/IP configuration exercises and submit your configuration files and test results.",
          dueDate: DateTime.now().add(const Duration(days: 9)),
          totalPoints: 65,
          acceptedFormats: [".pdf", ".txt"],
          maxFileSizeMB: 5,
          courseId: "c001",
          moduleId: "m003",
          lessonId: "l008",
        ),
        Assignment(
          isSubmitted: false,
          id: "a011",
          title: "Network Troubleshooting Lab",
          description: "Complete the network topology troubleshooting as outlined in the module 3 handbook. Submit the .pka file and a PDF summary report explaining the issues and solutions.",
          dueDate: DateTime.now().add(const Duration(days: 5)),
          totalPoints: 100,
          acceptedFormats: [".pdf", ".docx", ".pka"],
          maxFileSizeMB: 25,
          courseId: "c001",
          moduleId: "m003",
          lessonId: "l009",
        ),
        
        // Module 4 Assignments (locked)
        Assignment(
          isSubmitted: false,
          id: "a012",
          title: "Security Threats Analysis",
          description: "Analyze three recent cybersecurity incidents and explain the vulnerabilities that were exploited.",
          dueDate: DateTime.now().add(const Duration(days: 14)),
          totalPoints: 80,
          acceptedFormats: [".pdf", ".docx"],
          maxFileSizeMB: 10,
          courseId: "c001",
          moduleId: "m004",
          lessonId: "l010",
        ),
        Assignment(
          isSubmitted: false,
          id: "a013",
          title: "Encryption Implementation Project",
          description: "Implement basic encryption and decryption using provided tools. Document your process and results.",
          dueDate: DateTime.now().add(const Duration(days: 16)),
          totalPoints: 70,
          acceptedFormats: [".pdf", ".docx", ".zip"],
          maxFileSizeMB: 15,
          courseId: "c001",
          moduleId: "m004",
          lessonId: "l011",
        ),
        Assignment(
          isSubmitted: false,
          id: "a014",
          title: "Security Policy Development",
          description: "Develop a comprehensive security policy for a small business including malware prevention, password policies, and incident response.",
          dueDate: DateTime.now().add(const Duration(days: 15)),
          totalPoints: 90,
          acceptedFormats: [".pdf", ".docx"],
          maxFileSizeMB: 10,
          courseId: "c001",
          moduleId: "m004",
          lessonId: "l012",
        ),
      ],
      semester: "2024 Fall",
      credits: 3.0,
    ),
    
    Course(
      id: "c002",
      title: "Customer Service Excellence",
      code: "CS201",
      instructor: "Ms. Gordon",
      instructorEmail: "gordon@heart.edu.jm",
      category: "Soft Skills",
      categoryColor: const Color(0xFF76b081),
      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuDR4YDtwlmPYinoxLqV_8H0jiaOQO9R6O_hSY7PrvynhmMNpj3MZCBIKeNPLcX833NwSr3Nu9XRLApm5FWGW3dGBMMAnvKOAnjRuCFvAXQLR5TjTLNzYDyRh1quqzYF8S8QX9RoMGU90GLEn7qoHB1DeqlZfstcXRNxOuJSCOUEsXaNybrOQZ3KjUCabOP3F3VY4dvvuE-oUyz7siXDb_jSTVUJlBu7178TlsfeVeU9YbgCBzkn1rVchQQXKTVDuDX9Rpd0Z-Lv42M",
      progress: 0.25,
      completedModules: 1,
      totalModules: 4,
      description: "Develop essential customer service skills for professional workplace environments.",
      modules: [],
      assignments: [],
      semester: "2024 Fall",
      credits: 2.0,
    ),
    
    Course(
      id: "c003",
      title: "Occupational Health & Safety",
      code: "OHS101",
      instructor: "Dr. Richards",
      instructorEmail: "richards@heart.edu.jm",
      category: "Compliance",
      categoryColor: const Color(0xFFc0a07a),
      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCU6-r-s4caYwAm4-IOLsw48Q_7Ze80PmdwKNDSb1rLFk0T5iWP62-KspESuOiFS7151Y7rxLOd___zIhDM76F1Ie407YdQc8fGGHl1ECqHbKVzivAFMA3Zs9AkhwjdjCHxISmj9MZK7mK3mEj55R1my8rr0dLmxedskUIQpXPAJhWRVfKxpKpIzOvUjcBuwcu-TjTj6jORYsNPwXeDfRkatzfwxJH-tX84QDAnMvUeSM5HEQIp9Rjd0vZbJlbKDFZ9AYE1q3q46Sg",
      progress: 0.05,
      completedModules: 0,
      totalModules: 6,
      description: "Learn workplace safety protocols and occupational health standards.",
      modules: [],
      assignments: [],
      semester: "2024 Fall",
      credits: 2.0,
    ),
  ];

  static final List<ScheduleEvent> todaySchedule = [
    ScheduleEvent(
      id: "s001",
      title: "ICT Lab - Block B",
      subtitle: "Practical Session",
      startTime: DateTime.now().copyWith(hour: 9, minute: 0),
      endTime: DateTime.now().copyWith(hour: 10, minute: 30),
      location: "Lab B",
      courseId: "c001",
      isPrimary: true,
    ),
    ScheduleEvent(
      id: "s002",
      title: "Mathematics for Trades",
      subtitle: "Lecture - Room 4A",
      startTime: DateTime.now().copyWith(hour: 13, minute: 30),
      endTime: DateTime.now().copyWith(hour: 15, minute: 0),
      location: "Room 4A",
      courseId: "c002",
    ),
  ];

  static final List<Deadline> upcomingDeadlines = [
    Deadline(
      id: "d001",
      title: "Operating Systems Report",
      subtitle: "Due tomorrow, 11:59 PM",
      dueDate: DateTime.now().add(const Duration(days: 1)),
      color: Colors.orange,
      icon: Icons.assignment,
      courseId: "c001",
      type: "assignment",
    ),
    Deadline(
      id: "d002",
      title: "Hardware Components Quiz",
      subtitle: "Due in 2 days",
      dueDate: DateTime.now().add(const Duration(days: 2)),
      color: Colors.red,
      icon: Icons.priority_high,
      courseId: "c001",
      type: "quiz",
    ),
    Deadline(
      id: "d003",
      title: "Network Troubleshooting Lab",
      subtitle: "Due in 5 days",
      dueDate: DateTime.now().add(const Duration(days: 5)),
      color: Colors.green,
      icon: Icons.upload_file,
      courseId: "c001",
      type: "project",
    ),
  ];

  static final List<Grade> grades = [
    Grade(
      courseId: "c101",
      courseCode: "CS101",
      courseName: "Intro to Computer Systems",
      semester: "2023 Spring",
      credits: 3.0,
      letterGrade: "A",
      numericGrade: 95.0,
      isPassed: true,
    ),
    Grade(
      courseId: "c102",
      courseCode: "IT202",
      courseName: "Web Development Fundamentals",
      semester: "2023 Spring",
      credits: 4.0,
      letterGrade: "A-",
      numericGrade: 92.0,
      isPassed: true,
    ),
    Grade(
      courseId: "c001",
      courseCode: "ICT101",
      courseName: "Introduction to ICT",
      semester: "2024 Fall",
      credits: 3.0,
      letterGrade: "--",
      isPassed: false,
      isInProgress: true,
    ),
    Grade(
      courseId: "c103",
      courseCode: "EN101",
      courseName: "Technical Communication",
      semester: "2023 Fall",
      credits: 2.0,
      letterGrade: "B+",
      numericGrade: 87.0,
      isPassed: true,
    ),
  ];

  static final List<Announcement> announcements = [
    Announcement(
      id: "ann001",
      title: "Kingston Campus Announcement",
      message: "The main library will remain open until 10:00 PM throughout the final exam period.",
      postedDate: DateTime.now().subtract(const Duration(hours: 2)),
      isPinned: true,
    ),
    Announcement(
      id: "ann002",
      title: "ICT Lab Maintenance",
      message: "Computer Lab B will be closed for maintenance on Friday, October 27th.",
      postedDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Helper methods
  static Course? getCourseById(String id) {
    try {
      return courses.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Assignment> getAssignmentsByCourse(String courseId) {
    final course = getCourseById(courseId);
    return course?.assignments ?? [];
  }

  static List<Assignment> getAllAssignments() {
    return courses.expand((c) => c.assignments).toList();
  }

  static Assignment? getAssignmentById(String id) {
    try {
      return getAllAssignments().firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }
}