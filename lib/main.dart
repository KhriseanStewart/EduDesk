import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/main/MainLayout.dart';
import 'package:mac_app/src/mobile/main/MainLayout.dart';
import 'package:mac_app/src/screens/AuthScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gvvcltszdcsabmwwpxeo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd2dmNsdHN6ZGNzYWJtd3dweGVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjkzNzM1NDksImV4cCI6MjA4NDk0OTU0OX0.8BSsWQoWjS5dEbWDCY8MU8RGsQ87SrVkU5u8vHrjmTA',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduDesk - Terobytez',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4DA3B6)),
        useMaterial3: true,
      ),
      home: Platform.isAndroid || Platform.isIOS
          ? const _AuthGate(child: MobileLayout())
          : const _AuthGate(child: MainLayout()),
    );
  }
}

/// Shows [AuthScreen] when not signed in, otherwise [child] (MainLayout).
class _AuthGate extends StatefulWidget {
  final Widget child;

  const _AuthGate({required this.child});

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  late bool _isSignedIn;

  @override
  void initState() {
    super.initState();
    _isSignedIn = Supabase.instance.client.auth.currentSession != null;
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        setState(() {
          _isSignedIn = data.session != null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn) {
      return widget.child;
    }
    return const AuthScreen();
  }
}
