import 'package:flutter/material.dart';

void main() {
  runApp(const SmartStudyApp());
}

class SmartStudyApp extends StatelessWidget {
  const SmartStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Study Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          primary: const Color(0xFF1E88E5),
        ),
        useMaterial3: true,
      ),
      home: const SemesterSelectionScreen(),
    );
  }
}

class SemesterSelectionScreen extends StatefulWidget {
  const SemesterSelectionScreen({super.key});

  @override
  State<SemesterSelectionScreen> createState() => _SemesterSelectionScreenState();
}

class _SemesterSelectionScreenState extends State<SemesterSelectionScreen> {
  int? selectedSemester;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.school_rounded,
                        size: 70,
                        color: Color(0xFF1E88E5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'المساعد الدراسي الذكي',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'اختر الفصل الدراسي للبدء',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      DropdownButtonFormField<int>(
                        value: selectedSemester,
                        decoration: InputDecoration(
                          labelText: 'اختر السمستر (1 - 10)',
                          prefixIcon: const Icon(Icons.format_list_numbered),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: List.generate(10, (index) => index + 1)
                            .map((sem) => DropdownMenuItem(
                                  value: sem,
                                  child: Text('السمستر $sem'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSemester = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E88E5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: selectedSemester == null
                              ? null
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'تم اختيار السمستر $selectedSemester بنجاح!'),
                                    ),
                                  );
                                },
                          child: const Text(
                            'دخول',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
