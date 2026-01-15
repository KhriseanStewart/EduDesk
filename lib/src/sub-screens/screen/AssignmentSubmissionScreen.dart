import 'package:flutter/material.dart';
import 'package:mac_app/src/components/RouteName.dart';

class AssignmentSubmissionScreen extends StatelessWidget {
  const AssignmentSubmissionScreen({super.key});

  static const primary = Color(0xFF3CC2DD);
  static const border = Color(0xFFE8F0F2);
  static const muted = Color(0xFF538893);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// MAIN CONTENT
                Expanded(child: _MainContent()),

                const SizedBox(width: 32),

                /// SIDEBAR
                const SizedBox(width: 320, child: _Sidebar()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ===========================================================
   MAIN CONTENT
=========================================================== */

class _MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RouteName(),
        const SizedBox(height: 24),
        _Header(),
        const SizedBox(height: 24),
        _InstructionsCard(),
        const SizedBox(height: 24),
        _DropZone(),
        const SizedBox(height: 24),
        _UploadProgress(),
        const SizedBox(height: 24),
        _CommentsBox(),
        const SizedBox(height: 32),
        _ActionButtons(),
      ],
    );
  }
}

class _Breadcrumbs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: const [
        Text("Courses", style: TextStyle(color: Color(0xFF538893))),
        Text("/"),
        Text("Network Engineering", style: TextStyle(color: Color(0xFF538893))),
        Text("/"),
        Text(
          "Assignment Submission",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Network Troubleshooting Lab",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Color(0xFF3CC2DD),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.event, size: 16, color: Color(0xFF538893)),
                SizedBox(width: 6),
                Text("Due: Oct 24, 2023, 11:59 PM"),
                SizedBox(width: 16),
                Icon(Icons.grade, size: 16, color: Color(0xFF538893)),
                SizedBox(width: 6),
                Text("100 Points"),
              ],
            ),
          ],
        ),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.description),
          label: const Text("View Rubric"),
        ),
      ],
    );
  }
}

class _InstructionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.info, color: Color(0xFF3CC2DD)),
              SizedBox(width: 8),
              Text(
                "Instructions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            "Complete the network topology troubleshooting as outlined in the module 4 handbook. "
            "Submit the .pka file and a PDF summary report explaining the issues and solutions.",
            style: TextStyle(color: Color(0xFF538893), height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _DropZone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF3CC2DD).withOpacity(0.4),
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: const [
          Icon(Icons.cloud_upload, size: 48, color: Color(0xFF3CC2DD)),
          SizedBox(height: 12),
          Text(
            "Drag and drop files here",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            "Accepted formats: .pdf, .docx, .pka (Max 25MB)",
            style: TextStyle(color: Color(0xFF538893)),
          ),
        ],
      ),
    );
  }
}

class _UploadProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Color(0xFF3CC2DD)),
                  SizedBox(width: 8),
                  Text("Troubleshooting_Report_JohnDoe.pdf"),
                ],
              ),
              Text(
                "85%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3CC2DD),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const LinearProgressIndicator(value: 0.85),
        ],
      ),
    );
  }
}

class _CommentsBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Submission Comments (Optional)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Add a note for your instructor...",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: () {}, child: const Text("Save Draft")),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.send),
          label: const Text("Submit Assignment"),
        ),
      ],
    );
  }
}

/* ===========================================================
   SIDEBAR
=========================================================== */

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "SUBMISSION STATUS",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1,
                  color: Color(0xFF538893),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.history_toggle_off, size: 36, color: Colors.grey),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Not Submitted",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("First attempt pending"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _Card(
          child: Column(
            children: const [
              Text(
                "No previous submissions found.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/* ===========================================================
   SHARED CARD
=========================================================== */

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8F0F2)),
      ),
      child: child,
    );
  }
}
