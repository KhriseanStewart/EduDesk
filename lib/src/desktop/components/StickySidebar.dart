import 'package:flutter/material.dart';

class StickySidebar extends StatelessWidget {
  const StickySidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TodayScheduleCard(),
        SizedBox(height: 24),
        DeadlinesCard(),
      ],
    );
  }
}

class TodayScheduleCard extends StatelessWidget {
  const TodayScheduleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.event_note, color: Color(0xFF4DA3B6)),
                  SizedBox(width: 8),
                  Text(
                    "Today's Schedule",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                "Oct 24, 2024",
                style: TextStyle(fontSize: 12, color: Color(0xFF538893)),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _ScheduleItem(
            start: "9:00 AM",
            end: "10:30 AM",
            title: "ICT Lab - Block B",
            subtitle: "Practical Session",
            isPrimary: true,
          ),

          const SizedBox(height: 16),

          _ScheduleItem(
            start: "1:30 PM",
            end: "3:00 PM",
            title: "Mathematics for Trades",
            subtitle: "Lecture - Room 4A",
            isPrimary: false,
          ),

          const SizedBox(height: 16),

          // BUTTON
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                "View Full Timetable",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeadlinesCard extends StatelessWidget {
  const DeadlinesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.timer, color: Colors.redAccent),
              SizedBox(width: 8),
              Text(
                "Deadlines",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 20),

          _DeadlineItem(
            title: "Project Documentation",
            subtitle: "Due in 2 days",
            color: Colors.red,
            icon: Icons.priority_high,
          ),
          _DeadlineItem(
            title: "Quiz: Unit 4",
            subtitle: "Tomorrow, 11:59 PM",
            color: Colors.orange,
            icon: Icons.assignment,
          ),
          _DeadlineItem(
            title: "Lab Report #3",
            subtitle: "Due in 5 days",
            color: Colors.green,
            icon: Icons.upload_file,
          ),
        ],
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  final Widget child;
  const _BaseCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String start, end, title, subtitle;
  final bool isPrimary;

  const _ScheduleItem({
    required this.start,
    required this.end,
    required this.title,
    required this.subtitle,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 2,
          height: 48,
          color: isPrimary
              ? const Color(0xFF4DA3B6)
              : const Color(0xFF4DA3B6).withOpacity(0.2),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                start,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                end,
                style: const TextStyle(fontSize: 10, color: Color(0xFF538893)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF538893)),
            ),
          ],
        ),
      ],
    );
  }
}

class _DeadlineItem extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;

  const _DeadlineItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF538893),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.chevron_right, size: 18, color: Color(0xFF538893)),
        ],
      ),
    );
  }
}
