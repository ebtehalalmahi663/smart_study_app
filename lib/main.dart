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

// =============================================================
// الشاشة الأولى: اختيار الفصل الدراسي
// =============================================================
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

// =============================================================
// الشاشة الثانية: عرض المقررات الخاصة بالسمستر
// =============================================================
class CoursesListScreen extends StatelessWidget {
  final int semesterNumber;

  const CoursesListScreen({super.key, required this.semesterNumber});

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
          {'name': 'مقدمة في البرمجة', 'icon': Icons.code},
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
              elevation: 2,
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
                subtitle: const Text('اضغط لبدء المراجعة الذكية'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailChatScreen(
                        courseName: course['name'] as String,
                      ),
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

// =============================================================
// الشاشة الثالثة: تفاصيل المقرر والمساعد الذكي (AI Chat & PDF)
// =============================================================
class CourseDetailChatScreen extends StatefulWidget {
  final String courseName;

  const CourseDetailChatScreen({super.key, required this.courseName});

  @override
  State<CourseDetailChatScreen> createState() => _CourseDetailChatScreenState();
}

class _CourseDetailChatScreenState extends State<CourseDetailChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  String? uploadedFileName;
  
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'أهلاً بك! يمكنك رفع ملف المحاضرة (PDF) وسأقوم بمساعدتك في تلخيصه أو الإجابة عن أسئلتك وتوليد اختبارات عليه.'
    }
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userQuery = _messageController.text;
    setState(() {
      _messages.add({'isUser': true, 'text': userQuery});
      _messageController.clear();
    });

    // إجابة تجريبية للتفاعل
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _messages.add({
          'isUser': false,
          'text': 'بناءً على ملفات مقرر (${widget.courseName})، الإجابة هي: يتم تطبيق هذه المفاهيم في التحليل البرمجي والتطبيق العملي بشكل مباشر.'
        });
      });
    });
  }

  void _generateQuiz() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.quiz, color: Color(0xFF1E88E5)),
            SizedBox(width: 8),
            Text('اختبار تجريبي ذكي'),
          ],
        ),
        content: Text(
          'سؤال 1: ما هو المفهوم الأساسي لمقرر ${widget.courseName}؟\n\nأ) التصميم الذكي\nب) معالجة البيانات\nج) إدارة الأنظمة',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment),
            tooltip: 'توليد اختبار',
            onPressed: _generateQuiz,
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط معلومات الملف المرفوع
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf, color: Colors.red),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    uploadedFileName ?? 'لم يتم رفع ملف PDF للمحاضرة بعد',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      uploadedFileName = 'المحاضرة_الأولى.pdf';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم رفع ملف المحاضرة بنجاح!')),
                    );
                  },
                  icon: const Icon(Icons.upload_file, size: 18),
                  label: const Text('رفع PDF'),
                ),
              ],
            ),
          ),

          // قائمة المحادثة
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'] as bool;
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF1E88E5) : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: isUser ? Radius.zero : null,
                        bottomLeft: !isUser ? Radius.zero : null,
                      ),
                    ),
                    child: Text(
                      msg['text'] as String,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // حقل أدخال النص
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'اسأل المساعد الذكي عن الدرس...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF1E88E5),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
