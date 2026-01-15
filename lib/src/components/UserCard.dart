import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> userDetails = {
      "name": "Khrisean Stewart",
      "ID": "111 - 111 - 111",
      "avatar":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuDOV9ZqEQXNpGPLpvaModLNGhGuypdjyD8uxABTHjhUbSpFQxpgwOCH6Nyxzb3YW3H6dt4bzrV_2TShSbjrhGxv7OrL5IwewJCmtxcAe3PyVmDdauHJ0dxu5xevmY-8CbzBGkFgU6s7ryAPAdYSoYiI9JNW6VRKoRfs6MJ7UHaFNKOxmAC_miNprTdH51W3G_zwPeIvnuIKFk9i_Eft3N9r3pugXW6j2vhETNwRuXJi4FkCKqP5Z__uxZRBcIv_Q8PeGSRXP1-YP4w",
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF289F91).withOpacity(0.2),
                width: 2,
              ),
              image: DecorationImage(
                image: NetworkImage(userDetails['avatar']),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) =>
                    Icon(Icons.person, size: 30),
              ),
            ),
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
    Map<String, dynamic> userDetails = {
      "name": "Khrisean Stewart",
      "ID": "111 - 111 - 111",
      "avatar":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuDOV9ZqEQXNpGPLpvaModLNGhGuypdjyD8uxABTHjhUbSpFQxpgwOCH6Nyxzb3YW3H6dt4bzrV_2TShSbjrhGxv7OrL5IwewJCmtxcAe3PyVmDdauHJ0dxu5xevmY-8CbzBGkFgU6s7ryAPAdYSoYiI9JNW6VRKoRfs6MJ7UHaFNKOxmAC_miNprTdH51W3G_zwPeIvnuIKFk9i_Eft3N9r3pugXW6j2vhETNwRuXJi4FkCKqP5Z__uxZRBcIv_Q8PeGSRXP1-YP4w",
    };

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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(userDetails['avatar']),
                  onError: (exception, stackTrace) => Icon(Icons.person),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userDetails['name'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'ID: ${userDetails['ID']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF6B7280),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.logout, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}
