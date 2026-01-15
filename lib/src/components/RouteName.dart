import 'package:flutter/material.dart';

class RouteName extends StatelessWidget {
  const RouteName({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'MODULE 2',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF289F91),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.chevron_right, size: 16, color: Colors.grey.shade400),
        const SizedBox(width: 8),
        const Text(
          'SOFTWARE & OS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF289F91),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
