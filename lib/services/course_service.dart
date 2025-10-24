// lib/services/course_service.dart (CLEAN START)

import 'dart:async';
import '../models/course.dart';

class CourseService {

  // CRITICAL CHANGE: The mock database list is now EMPTY
  // You will create all courses manually via the app's "+" button.
  static final List<Course> _mockCourses = [];

  // Start ID tracking from 1
  static int _nextId = 1;

  // Simulates network latency
  Future<void> _simulateDelay() => Future.delayed(const Duration(milliseconds: 500));

  // R: READ (GET /api/courses/)
  Future<List<Course>> fetchCourses() async {
    await _simulateDelay();
    // Returns the empty list initially.
    return List.from(_mockCourses);
  }

  // C: CREATE (POST /api/courses/)
  Future<Course> createCourse(Course newCourse) async {
    await _simulateDelay();
    final courseWithId = Course(
      id: _nextId++,
      programName: newCourse.programName,
      courseName: newCourse.courseName,
      branch: newCourse.branch,
      year: newCourse.year,
      semester: newCourse.semester,
      section: newCourse.section,
      instructorName: newCourse.instructorName,
      startDate: newCourse.startDate,
      endDate: newCourse.endDate,
    );

    // Add the newly created course to the list
    _mockCourses.add(courseWithId);

    return courseWithId;
  }

  // U: UPDATE (PUT/PATCH /api/courses/{id}/)
  Future<Course> updateCourse(Course updatedCourse) async {
    await _simulateDelay();
    final index = _mockCourses.indexWhere((c) => c.id == updatedCourse.id);
    if (index != -1) {
      _mockCourses[index] = updatedCourse;
      return updatedCourse;
    }
    throw Exception("Course not found for update");
  }

  // D: DELETE (DELETE /api/courses/{id}/)
  Future<void> deleteCourse(int id) async {
    await _simulateDelay();
    _mockCourses.removeWhere((c) => c.id == id);
  }
}