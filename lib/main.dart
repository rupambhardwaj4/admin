import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/course_list_screen.dart';
import 'services/api_service.dart';

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
      home: HelloScreen(),
    );
  }
}

class HelloScreen extends StatefulWidget {
  const HelloScreen({super.key});

  @override
  State<HelloScreen> createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen> {
  String message = "Loading...";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final api = ApiService();
    try {
      final msg = await api.getHello();
      setState(() => message = msg);
    } catch (e) {
      setState(() => message = "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Training Program")),
      body: Center(child: Text(message, style: const TextStyle(fontSize: 20))),
    );
  }
}
