import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mac_app/src/desktop/main/MainLayout.dart';
import 'package:mac_app/src/mobile/main/MainLayout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduDesk - Terobytez',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Platform.isAndroid || Platform.isIOS
          ? MobileLayout()
          : MainLayout()
    );
  }
}
