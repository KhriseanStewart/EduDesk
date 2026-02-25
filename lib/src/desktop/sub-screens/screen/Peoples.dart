import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/LMS%20models/lms_models.dart';
import 'package:mac_app/src/services/supabase_service.dart';

class Peoples extends StatefulWidget {
  final List<String> users;
  const Peoples({super.key, required this.users});

  @override
  State<Peoples> createState() => _PeoplesState();
}

class _PeoplesState extends State<Peoples> {
  final SupabaseService _supabaseService = SupabaseService();
  Future<List<User>>? _usersFuture;

  @override
  void initState() {
    super.initState();
    if (widget.users.isNotEmpty) {
      _usersFuture = _supabaseService.getUsersByIds(widget.users) as Future<List<User>>?;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.7),
      body: widget.users.isEmpty
          ? const Expanded(child: Center(child: Text("No one is in this class")))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "People",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF101918),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _usersFuture == null 
                      ? const Center(child: Text("No users found."))
                      : FutureBuilder<List<User>>(
                      future: _usersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        }

                        final usersData = snapshot.data ?? [];

                        if (usersData.isEmpty) {
                          return const Center(child: Text("No user details found."));
                        }

                        return ListView.separated(
                          itemCount: usersData.length,
                          itemBuilder: (context, index) {
                            final user = usersData[index];
                            final role = user.role == "student" ? "Student" : "Teacher";
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  role,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
