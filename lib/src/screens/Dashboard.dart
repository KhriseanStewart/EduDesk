import 'package:flutter/material.dart';
import 'package:mac_app/src/components/CourseCard.dart';
import 'package:mac_app/src/components/CustomContainer.dart';
import 'package:mac_app/src/components/StickySidebar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    size.width > 1302
                        ? AnnouncementBanner(context)
                        : const SizedBox.shrink(),
                    const SizedBox(height: 16),
                    CurrentCourses(context, size),
                  ],
                ),
              ),
            ),
            // Fixed sticky sidebar
            size.width > 1302
                ? SizedBox(
                    width: size.width * 0.3,
                    child: const StickySidebar(),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget AnnouncementBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD54F).withOpacity(0.1), // accent-yellow/10
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFD54F).withOpacity(0.3), // accent-yellow/30
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;

          return Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: isMobile
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              // LEFT SIDE
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon circle
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD54F),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.campaign,
                        color: Color(0xFF1A2B2E),
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Text content
                  Flexible(
                    child: Column(
                      crossAxisAlignment: isMobile
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Kingston Campus Announcement",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "The main library will remain open until 10:00 PM throughout the final exam period.",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (!isMobile) const SizedBox(width: 24),
              if (isMobile) const SizedBox(height: 16),

              // BUTTON
              ElevatedButton(
                onPressed: () {
                  // TODO: navigate to details
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD54F),
                  foregroundColor: const Color(0xFF1A2B2E),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "View Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget CurrentCourses(BuildContext context, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          "My Current Courses",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 15),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            maxCrossAxisExtent: 420,
            childAspectRatio: size.width > 1201 ? 1 : 1.35,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return CourseCard(
              title: "ICT Level 1",
              instructor: "Dr. Thompson",
              progress: 0.75,
              statusText: "Progressing well",
            );
          },
        ),
      ],
    );
  }
}
