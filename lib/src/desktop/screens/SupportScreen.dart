// lib/src/screens/SupportScreen.dart

import 'package:flutter/material.dart';
import 'package:mac_app/src/utils/responsive.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedCategory = 'Technical Issue';
  String selectedPriority = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final padding = context.responsivePadding;
                final useColumn = context.isCompact || constraints.maxWidth < Breakpoint.medium;
                return SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: useColumn
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildQuickActions(),
                            const SizedBox(height: 24),
                            _buildSupportTicketForm(),
                            const SizedBox(height: 24),
                            _buildContactInfo(),
                            const SizedBox(height: 24),
                            _buildFAQSection(),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  _buildQuickActions(),
                                  const SizedBox(height: 24),
                                  _buildSupportTicketForm(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  _buildContactInfo(),
                                  const SizedBox(height: 24),
                                  _buildFAQSection(),
                                ],
                              ),
                            ),
                          ],
                        ),
                );
                  },
                ),
              ),
          ],
        ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final padding = context.responsivePadding;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          const Text(
            "Support Center",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.history),
            label: const Text("My Tickets"),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
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
            "Quick Actions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _QuickActionCard(
                icon: Icons.description,
                title: "View Guides",
                color: Colors.blue,
                onTap: () {},
              ),
              _QuickActionCard(
                icon: Icons.video_library,
                title: "Video Tutorials",
                color: Colors.purple,
                onTap: () {},
              ),
              _QuickActionCard(
                icon: Icons.forum,
                title: "Student Forum",
                color: Colors.green,
                onTap: () {},
              ),
              _QuickActionCard(
                icon: Icons.live_help,
                title: "Live Chat",
                color: Colors.orange,
                onTap: () {},
              ),
              _QuickActionCard(
                icon: Icons.schedule,
                title: "Book Appointment",
                color: Colors.red,
                onTap: () {},
              ),
              _QuickActionCard(
                icon: Icons.feedback,
                title: "Send Feedback",
                color: Colors.teal,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSupportTicketForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Submit a Support Ticket",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Category Dropdown
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Technical Issue", child: Text("Technical Issue")),
                DropdownMenuItem(value: "Account Access", child: Text("Account Access")),
                DropdownMenuItem(value: "Course Content", child: Text("Course Content")),
                DropdownMenuItem(value: "Grades & Assignments", child: Text("Grades & Assignments")),
                DropdownMenuItem(value: "Other", child: Text("Other")),
              ],
              onChanged: (value) {
                setState(() => selectedCategory = value!);
              },
            ),
            const SizedBox(height: 16),
            
            // Priority
            DropdownButtonFormField<String>(
              value: selectedPriority,
              decoration: const InputDecoration(
                labelText: "Priority",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Low", child: Text("Low")),
                DropdownMenuItem(value: "Medium", child: Text("Medium")),
                DropdownMenuItem(value: "High", child: Text("High")),
                DropdownMenuItem(value: "Urgent", child: Text("Urgent")),
              ],
              onChanged: (value) {
                setState(() => selectedPriority = value!);
              },
            ),
            const SizedBox(height: 16),
            
            // Subject
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Subject",
                border: OutlineInputBorder(),
                hintText: "Brief description of your issue",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a subject';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Description
            TextFormField(
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
                hintText: "Provide detailed information about your issue...",
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // File Upload
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.attach_file),
              label: const Text("Attach Files (Optional)"),
            ),
            const SizedBox(height: 24),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Support ticket submitted!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4DA3B6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Submit Ticket",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
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
            "Contact Information",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _ContactItem(
            icon: Icons.phone,
            title: "Phone Support",
            content: "+1 876-555-HEART",
            subtitle: "Mon-Fri, 8AM-5PM",
          ),
          const SizedBox(height: 12),
          _ContactItem(
            icon: Icons.email,
            title: "Email Support",
            content: "support@heart.edu.jm",
            subtitle: "Response within 24 hours",
          ),
          const SizedBox(height: 12),
          _ContactItem(
            icon: Icons.location_on,
            title: "Campus Location",
            content: "Kingston Campus",
            subtitle: "34 Marescaux Road",
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            "Office Hours",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Monday - Friday: 8:00 AM - 5:00 PM\nSaturday: 9:00 AM - 1:00 PM\nSunday: Closed",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
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
            "Frequently Asked Questions",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _FAQItem(
            question: "How do I reset my password?",
            answer: "Click 'Forgot Password' on the login page and follow the instructions.",
          ),
          _FAQItem(
            question: "How do I submit an assignment?",
            answer: "Navigate to your course, select the assignment, and click 'Submit'.",
          ),
          _FAQItem(
            question: "Where can I view my grades?",
            answer: "Go to the Grades section in the main navigation menu.",
          ),
          _FAQItem(
            question: "How do I contact my instructor?",
            answer: "Use the contact button in your course details page.",
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {},
            child: const Text("View All FAQs →"),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final String subtitle;

  const _ContactItem({
    required this.icon,
    required this.title,
    required this.content,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF4DA3B6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF4DA3B6), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}