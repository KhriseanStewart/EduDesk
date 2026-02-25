import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/components/Avatar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final name = user?.userMetadata?['name'] as String? ?? user?.email ?? 'User';
    final email = user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F181A),
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: SafeArea(
        child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  Avatar(
                    imageUrl: user?.userMetadata?['avatar_url'] as String?,
                    name: name,
                    size: 72,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverToBoxAdapter(
            child: ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text('Sign out', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
              },
            ),
          ),
          const SliverToBoxAdapter(child: Divider(height: 32)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Account',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                leading: Icon(Icons.email_outlined, color: Colors.grey.shade600),
                title: const Text('Email'),
                subtitle: Text(email.isEmpty ? '—' : email),
              ),
              ListTile(
                leading: Icon(Icons.badge_outlined, color: Colors.grey.shade600),
                title: const Text('Display name'),
                subtitle: Text(name),
              ),
            ]),
          ),
        ],
        ),
      ),
    );
  }
}
