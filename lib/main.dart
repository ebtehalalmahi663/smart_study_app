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
        fontFamily: 'Roboto',
      ),
      home: const SemesterSelectionScreen(),
    );
  }
}

// -------------------------------------------------------------
// الشاشة الأولى: اختيار الفصل الدراسي
// -------------------------------------------------------------
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CoursesListScreen(
                                        semesterNumber: selectedSemester!,
                                      ),
                                    ),
                                  );
                                },
                          child: const Text(
                            'عرض المقررات',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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

// -------------------------------------------------------------
// الشاشة الثانية: عرض المقررات الخاصة بالسمستر المختار
// -------------------------------------------------------------
class CoursesListScreen extends StatelessWidget {
  final int semesterNumber;

  const CoursesListScreen({super.key, required this.semesterNumber});

  // قائمة المقرارات لكل سمستر
  List<Map<String, dynamic>> _getCoursesForSemester(int sem) {
    switch (sem) {
      case 6:
        return [
          {'name': 'الذكاء الاصطناعي (AI)', 'icon': Icons.psychology},
          {'name': 'رسم الحاسوب (Computer Graphics)', 'icon': Icons.palette},
          {'name': 'قواعد البيانات (Database Systems)', 'icon': Icons.storage},
          {'name': 'هندسة البرمجيات (Software Engineering)', 'icon': Icons.developer_mode},
          {'name': 'تقنيات الإنترنت (Internet Techniques)', 'icon': Icons.web},
          {'name': 'مبادئ التسويق (Marketing)', 'icon': Icons.campaign},
          {'name': 'مبادئ المحاسبة (Accounting)', 'icon': Icons.calculate},
          {'name': 'النمذجة والمحاكاة (Modeling & Simulation)', 'icon': Icons.analytics},
        ];
      default:
        return [
          {'name': 'برمجة الحاسوب', 'icon': Icons.code},
          {'name': 'تراكيب البيانات', 'icon': Icons.account_tree},
          {'name': 'الرياضيات المتقطعة', 'icon': Icons.functions},
          {'name': 'شبكات الحاسوب', 'icon': Icons.network_check},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final courses = _getCoursesForSemester(semesterNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text('مقررات السمستر $semesterNumber'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFF5F7FA),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF1E88E5).withOpacity(0.1),
                  child: Icon(
                    course['icon'] as IconData,
                    color: const Color(0xFF1E88E5),
                  ),
                ),
                title: Text(
                  course['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: const Text('اضغط للتصفح والمساعد الذكي'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم اختيار مقرر: ${course['name']}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
