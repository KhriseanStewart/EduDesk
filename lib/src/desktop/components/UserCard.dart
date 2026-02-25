import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Avatar.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> userDetails = {
      "name": "Khrisean Stewart",
      "ID": "111 - 111 - 111",
      "avatar": "",
    };
    return Container(
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
              Text(
                userDetails['name'],
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                userDetails['ID'].toString(),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Avatar(
            imageUrl: userDetails['avatar'] as String?,
            name: userDetails['name'] as String?,
            size: 40,
          ),
        ],
      ),
    );
  }
}

class UserCard2 extends StatelessWidget {
  const UserCard2({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final name = user?.userMetadata?['name'] as String? ?? user?.email ?? 'User';
    final email = user?.email ?? '';
    final avatarUrl = user?.userMetadata?['avatar_url'] as String?;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: const Color(0xFFF3F4F6), width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Avatar(
              imageUrl: avatarUrl,
              name: name,
              size: 40,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
              },
              icon: Icon(Icons.logout, color: Colors.red.shade700),
              tooltip: 'Sign out',
            ),
          ],
        ),
      ),
    );
  }
}

class UserCard3 extends StatelessWidget {
  const UserCard3({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> userDetails = {
      "name": "Khrisean Stewart",
      "ID": "111 - 111 - 111",
      "avatar": "",
    };

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: const Color(0xFFF3F4F6), width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            Avatar(
              imageUrl: userDetails['avatar'] as String?,
              name: userDetails['name'] as String?,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
