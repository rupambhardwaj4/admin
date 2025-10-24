// lib/screens/course_list_screen.dart

import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import 'course_form_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final CourseService _courseService = CourseService();
  late Future<List<Course>> _coursesFuture;

  // R: READ: Function to fetch data and refresh the UI
  void _fetchCourses() {
    setState(() {
      _coursesFuture = _courseService.fetchCourses();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  // D: DELETE: Function to remove an item via the service
  void _deleteCourse(int id) async {
    try {
      await _courseService.deleteCourse(id);
      _fetchCourses(); // Refresh the list after successful deletion
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course ID $id deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete course: $e')),
        );
      }
    }
  }

  // Helper to navigate to Form Screen (used for C and U) and refresh
  void _navigateAndRefresh(Course? course) async {
    // Navigate and wait for a result (true is returned on successful save/creation)
    final bool? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => CourseFormScreen(courseToEdit: course),
      ),
    );
    if (result == true) {
      _fetchCourses(); // Re-fetch the data to update the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Management (CRUD Demo)'),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<List<Course>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Message when the mock database is empty
            return const Center(child: Text('No courses found. Add one!'));
          }

          final courses = snapshot.data!;
          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (ctx, index) {
              final course = courses[index];
              return Dismissible(
                // D: DELETE (Swipe action)
                key: ValueKey(course.id!),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white, size: 30),
                ),
                onDismissed: (direction) {
                  _deleteCourse(course.id!);
                },
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    // U: UPDATE (Tap to edit)
                    // Displaying the essential details
                    title: Text(
                      '${course.programName} - ${course.courseName}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Branch: ${course.branch} | Year: ${course.year} | Sem: ${course.semester} | Sec: ${course.section}\nInstructor: ${course.instructorName} | Starts: ${course.startDate}',
                    ),
                    isThreeLine: true, // Needed to show all the subtitle info
                    trailing: const Icon(Icons.edit, color: Colors.blue),
                    onTap: () => _navigateAndRefresh(course),
                  ),
                ),
              );
            },
          );
        },
      ),
      // C: CREATE (Floating action button to add a new course)
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndRefresh(null),
        tooltip: 'Add New Course',
        child: const Icon(Icons.add),
      ),
    );
  }
}