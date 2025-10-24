// lib/main.dart

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/course_list_screen.dart';

void main() {
  // Initialize date formatting data (required by the intl package for DatePicker functionality)
  initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard CRUD Demo',
      debugShowCheckedModeBanner: false, // Turn off the debug banner
      theme: ThemeData(
        // Use an appealing primary color
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      // Set the CourseListScreen as the home page
      home: const CourseListScreen(),
    );
  }
}