// lib/models/course.dart (UPDATED)

class Course {
  final int? id;
  final String programName;      // New Field
  final String courseName;       // Renamed from 'name'
  final String branch;           // New Field
  final String year;             // New Field
  final String semester;         // New Field
  final String section;          // New Field
  final String instructorName;
  final String startDate;
  final String endDate;

  Course({
    this.id,
    required this.programName,
    required this.courseName,
    required this.branch,
    required this.year,
    required this.semester,
    required this.section,
    required this.instructorName,
    required this.startDate,
    required this.endDate,
  });

  // Method to convert a Course object to a JSON map (for API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'program_name': programName,    // Added
      'course_name': courseName,      // Renamed
      'branch': branch,               // Added
      'year': year,                   // Added
      'semester': semester,           // Added
      'section': section,             // Added
      'instructor_name': instructorName,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}