import 'package:flutter/material.dart';
import 'package:mac_app/src/components/RouteName.dart';

class GradesTranscriptScreen extends StatelessWidget {
  const GradesTranscriptScreen({super.key});

  static const primary = Color(0xFF2D7786);
  static const passed = Color(0xFF39B34A);
  static const progress = Color(0xFFFFC140);
  static const muted = Color(0xFF5C828A);
  static const border = Color(0xFFD4E0E2);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RouteName(),
                const SizedBox(height: 24),
                _Header(),
                const SizedBox(height: 32),
                _StatsGrid(),
                const SizedBox(height: 32),
                _GradesTable(),
                const SizedBox(height: 32),
                _VerificationNote(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ===========================================================
   BREADCRUMBS + HEADER
=========================================================== */

class _Breadcrumbs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.home, size: 14, color: GradesTranscriptScreen.muted),
        SizedBox(width: 4),
        Text(
          "Home",
          style: TextStyle(fontSize: 12, color: GradesTranscriptScreen.muted),
        ),
        SizedBox(width: 8),
        Text("/", style: TextStyle(color: GradesTranscriptScreen.border)),
        SizedBox(width: 8),
        Text(
          "Grades & Transcript",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Grades & Transcript",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 520,
              child: Text(
                "Your official academic record including cumulative performance, earned credits, and status of all enrolled programs.",
                style: TextStyle(color: GradesTranscriptScreen.muted),
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download),
          label: const Text("Download Official Transcript (PDF)"),
          style: ElevatedButton.styleFrom(
            backgroundColor: GradesTranscriptScreen.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

/* ===========================================================
   STATS
=========================================================== */

class _StatsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 4 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _StatCard(
          title: "Cumulative GPA",
          value: "3.85 / 4.0",
          footer: "Top 5% of Cohort",
        ),
        _CreditsCard(),
        _StatCard(
          title: "Courses Passed",
          value: "12 / 14",
          footer: "On track for graduation",
        ),
        _StatCard(
          title: "Current Term",
          value: "2024 Fall",
          footer: "Ends in 24 days",
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String footer;

  const _StatCard({
    required this.title,
    required this.value,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: GradesTranscriptScreen.muted,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            footer,
            style: const TextStyle(
              fontSize: 12,
              color: GradesTranscriptScreen.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditsCard extends StatelessWidget {
  const _CreditsCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "CREDITS EARNED",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: GradesTranscriptScreen.muted,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "45 Credits",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.75,
              minHeight: 6,
              backgroundColor: Color(0xFFEAF0F1),
              valueColor: AlwaysStoppedAnimation(
                GradesTranscriptScreen.primary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "75% of program completed",
            style: TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: GradesTranscriptScreen.muted,
            ),
          ),
        ],
      ),
    );
  }
}

/* ===========================================================
   TABLE
=========================================================== */

class _GradesTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _TableHeader(),
          const Divider(height: 1),
          _TableRowData(
            "CS101",
            "Intro to Computer Systems",
            "2023 Spring",
            "3.0",
            "A",
            true,
          ),
          _TableRowData(
            "IT202",
            "Web Development Fundamentals",
            "2023 Spring",
            "4.0",
            "A-",
            true,
          ),
          _TableRowData(
            "DS301",
            "Database Design & SQL",
            "2024 Fall",
            "3.0",
            "--",
            false,
            inProgress: true,
          ),
          _TableRowData(
            "EN101",
            "Technical Communication",
            "2023 Fall",
            "2.0",
            "B+",
            true,
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: const [
          _TH("CODE", 1),
          _TH("COURSE NAME", 3),
          _TH("SEMESTER", 2),
          _TH("CREDITS", 1),
          _TH("GRADE", 1),
          _TH("STATUS", 2),
        ],
      ),
    );
  }
}

class _TableRowData extends StatelessWidget {
  final String code, name, semester, credits, grade;
  final bool passed;
  final bool inProgress;

  const _TableRowData(
    this.code,
    this.name,
    this.semester,
    this.credits,
    this.grade,
    this.passed, {
    this.inProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: GradesTranscriptScreen.border)),
      ),
      child: Row(
        children: [
          _TD(code, 1, bold: true, color: GradesTranscriptScreen.primary),
          _TD(name, 3, bold: true),
          _TD(semester, 2),
          _TD(credits, 1),
          _TD(grade, 1, bold: true),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _StatusChip(passed: passed, inProgress: inProgress),
            ),
          ),
        ],
      ),
    );
  }
}

class _TH extends StatelessWidget {
  final String text;
  final int flex;
  const _TH(this.text, this.flex);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          color: GradesTranscriptScreen.muted,
        ),
      ),
    );
  }
}

class _TD extends StatelessWidget {
  final String text;
  final int flex;
  final bool bold;
  final Color? color;

  const _TD(this.text, this.flex, {this.bold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool passed;
  final bool inProgress;

  const _StatusChip({required this.passed, this.inProgress = false});

  @override
  Widget build(BuildContext context) {
    final color = passed
        ? GradesTranscriptScreen.passed
        : GradesTranscriptScreen.progress;

    final label = passed ? "PASSED" : "IN PROGRESS";

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
      ),
    );
  }
}

/* ===========================================================
   FOOTER NOTE
=========================================================== */

class _VerificationNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GradesTranscriptScreen.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: GradesTranscriptScreen.primary.withOpacity(0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.verified, color: GradesTranscriptScreen.primary),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Official Document Verification",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: GradesTranscriptScreen.primary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "This record is generated by the HEART NSTA Trust LMS. "
                  "Official copies are only valid when stamped by the Registrar.",
                  style: TextStyle(
                    fontSize: 12,
                    color: GradesTranscriptScreen.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ===========================================================
   SHARED CARD
=========================================================== */

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _Card({required this.child, this.padding = const EdgeInsets.all(20)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: GradesTranscriptScreen.border),
      ),
      child: child,
    );
  }
}
