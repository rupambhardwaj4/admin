// lib/screens/course_form_screen.dart (FINAL: ALL FIELDS USE DROPDOWN/DATEPICKER, EXCEPT COURSE NAME/TITLE)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/course.dart';
import '../services/course_service.dart';

// --- DEFINING SELECT OPTIONS ---
// 1. Program Names (Used for Conditional Branch Logic)
const List<String> programOptions = ['B.Tech', 'BBA', 'BCA', 'BPHARMA', 'MCA'];

// 2. Conditional Branch Options (MAPPING)
const Map<String, List<String>> branchOptionsMap = {
  'B.Tech': ['Computer Science and Engineering', 'ECE', 'ME', 'CE'],
  'BBA': ['Finance', 'Marketing', 'HR'],
  'BCA': ['General', 'Data Science', 'Cloud Computing'],
  'BPHARMA': ['General'],
  'MCA': ['General', 'Cloud Technology'],
};

// 3. Years
const List<String> yearOptions = ['1', '2', '3', '4'];
// 4. Semesters
const List<String> semesterOptions = ['1', '2', '3', '4', '5', '6', '7', '8'];
// 5. Sections
const List<String> sectionOptions = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
// 6. Instructors
const List<String> instructorOptions = [
  'Priya Sharma', 'Rajesh Kumar', 'Anjali Singh', 'Vikram Soni',
  'Neha Gupta', 'Sanjay Dutt', 'Divya Patel', 'Gaurav Jain',
  'Meera Menon', 'Rohan Verma'
];


class CourseFormScreen extends StatefulWidget {
  final Course? courseToEdit;
  const CourseFormScreen({super.key, this.courseToEdit});

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _CourseFormScreenState extends State<CourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final CourseService _courseService = CourseService();

  // --------------------------------------------------
  // CONTROLLERS (For Manual Text Input/Date Pickers)
  // --------------------------------------------------
  // 1. Course Name/Title - Remains manual text input
  late TextEditingController _courseNameController;
  // 2. Dates - Manual/Picker Input
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  // --------------------------------------------------
  // STATE VARIABLES (For Dropdown Selection)
  // --------------------------------------------------
  String? _selectedProgram; // NEW: Now a state variable for Dropdown
  String? _selectedBranch;
  String? _selectedYear;
  String? _selectedSemester;
  String? _selectedSection;
  String? _selectedInstructor;

  @override
  void initState() {
    super.initState();
    final c = widget.courseToEdit;

    // Initialize Controllers
    _courseNameController = TextEditingController(text: c?.courseName ?? '');
    _startDateController = TextEditingController(text: c?.startDate ?? '');
    _endDateController = TextEditingController(text: c?.endDate ?? '');

    // Initialize Dropdown states from existing Course data
    _selectedProgram = c?.programName; // NEW
    _selectedBranch = c?.branch;
    _selectedYear = c?.year;
    _selectedSemester = c?.semester;
    _selectedSection = c?.section;
    _selectedInstructor = c?.instructorName;
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  // Date Picker Logic (Unchanged)
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  void _submitForm() async {
    // Manually validate all required dropdowns
    if (_selectedProgram == null || _selectedBranch == null || _selectedYear == null ||
        _selectedSemester == null || _selectedSection == null || _selectedInstructor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select options for all required fields.')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final courseData = Course(
        id: widget.courseToEdit?.id,
        programName: _selectedProgram!,      // Dropdown
        courseName: _courseNameController.text, // Text Field
        branch: _selectedBranch!,            // Dropdown
        year: _selectedYear!,                // Dropdown
        semester: _selectedSemester!,        // Dropdown
        section: _selectedSection!,          // Dropdown
        instructorName: _selectedInstructor!,// Dropdown
        startDate: _startDateController.text,
        endDate: _endDateController.text,
      );

      try {
        if (widget.courseToEdit == null) {
          await _courseService.createCourse(courseData);
        } else {
          await _courseService.updateCourse(courseData);
        }

        if (mounted) Navigator.pop(context, true);

      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save course: $e')),
          );
        }
      }
    }
  }

  // Reusable Dropdown Widget
  Widget _buildDropdown(String label, List<String> options, String? currentValue, ValueChanged<String?> onChanged) {
    bool disabled = options.isEmpty;

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        enabled: !disabled,
      ),
      value: currentValue,
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: disabled ? null : onChanged,
      validator: (value) => value == null ? 'Please select a $label' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.courseToEdit != null;

    // Get the BRANCH options based on the currently selected Program
    final List<String> currentBranchOptions =
    _selectedProgram != null && branchOptionsMap.containsKey(_selectedProgram)
        ? branchOptionsMap[_selectedProgram]!
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Course' : 'Create New Course'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 1. Program Name (Dropdown - NOW A DROPDOWN)
              _buildDropdown(
                '1. Program Name',
                programOptions,
                _selectedProgram,
                    (newValue) {
                  setState(() {
                    _selectedProgram = newValue;
                    // CRITICAL: Clear Branch selection when Program changes
                    _selectedBranch = null;
                  });
                },
              ),
              const SizedBox(height: 15),
              // 2. Course Name (Manual Input)
              TextFormField(
                controller: _courseNameController,
                decoration: const InputDecoration(labelText: '2. Course Name/Title'),
                validator: (value) => value!.isEmpty ? 'Course Name is required' : null,
              ),
              const SizedBox(height: 15),

              // 3. Branch (Dropdown - Conditional on Program Name)
              _buildDropdown(
                '3. Branch',
                currentBranchOptions,
                _selectedBranch,
                    (newValue) => setState(() => _selectedBranch = newValue),
              ),
              const SizedBox(height: 15),

              // 4/5. Year and Semester (Row of Dropdowns)
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      '4. Year',
                      yearOptions,
                      _selectedYear,
                          (newValue) => setState(() => _selectedYear = newValue),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildDropdown(
                      '5. Semester',
                      semesterOptions,
                      _selectedSemester,
                          (newValue) => setState(() => _selectedSemester = newValue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // 6. Section (Dropdown)
              _buildDropdown(
                '6. Section',
                sectionOptions,
                _selectedSection,
                    (newValue) => setState(() => _selectedSection = newValue),
              ),
              const SizedBox(height: 15),
              // 7. Instructor Name (Dropdown)
              _buildDropdown(
                '7. Instructor Name',
                instructorOptions,
                _selectedInstructor,
                    (newValue) => setState(() => _selectedInstructor = newValue),
              ),
              const SizedBox(height: 15),
              // 8. Start Date (Date Picker)
              TextFormField(
                controller: _startDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: '8. Start Date (YYYY-MM-DD)',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, _startDateController),
                validator: (value) => value!.isEmpty ? 'Start Date is required' : null,
              ),
              const SizedBox(height: 15),
              // 9. End Date (Date Picker)
              TextFormField(
                controller: _endDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: '9. End Date (YYYY-MM-DD)',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, _endDateController),
                validator: (value) => value!.isEmpty ? 'End Date is required' : null,
              ),
              const SizedBox(height: 40),
              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(isEditing ? 'SAVE CHANGES' : 'CREATE COURSE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}