import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const SmartStudyApp());
}

class SmartStudyApp extends StatelessWidget {
  const SmartStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'المساعد الدراسي الذكي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: const Color(0xFFF5F9FC),
        fontFamily: 'Roboto',
      ),
      home: const CollegesScreen(),
    );
  }
}

class CollegesScreen extends StatelessWidget {
  const CollegesScreen({super.key});

  final List<Map<String, dynamic>> colleges = const [
    {
      'name': 'كلية علوم الحاسوب وتكنولوجيا المعلومات',
      'icon': Icons.computer,
      'departments': ['علوم الحاسوب', 'تقنية المعلومات', 'نظم المعلومات'],
    },
    {
      'name': 'كلية الهندسة',
      'icon': Icons.engineering,
      'departments': ['الهندسة المدنية', 'الهندسة الكهربائية', 'الميكانيكا'],
    },
    {
      'name': 'كلية الاقتصاد',
      'icon': Icons.business_center,
      'departments': ['إدارة الأعمال', 'المحاسبة', 'الاقتصاد'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المساعد الدراسي الذكي'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0288D1),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: colleges.length,
        itemBuilder: (context, index) {
          final college = colleges[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFE1F5FE),
                child: Icon(college['icon'], color: const Color(0xFF0288D1), size: 30),
              ),
              title: Text(
                college['name'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text('عدد التخصصات: ${(college['departments'] as List).length}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DepartmentsScreen(
                      collegeName: college['name'],
                      departments: List<String>.from(college['departments']),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DepartmentsScreen extends StatelessWidget {
  final String collegeName;
  final List<String> departments;

  const DepartmentsScreen({
    super.key,
    required this.collegeName,
    required this.departments,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(collegeName),
        backgroundColor: const Color(0xFF0288D1),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final dept = departments[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.school, color: Color(0xFF0288D1)),
              title: Text(dept, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SemestersScreen(
                      college: collegeName,
                      department: dept,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
class SemestersScreen extends StatelessWidget {
  final String college;
  final String department;

  const SemestersScreen({
    super.key,
    required this.college,
    required this.department,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الفصول الدراسية - $department'),
        backgroundColor: const Color(0xFF0288D1),
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          final semNum = index + 1;
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CoursesListScreen(
                    college: college,
                    department: department,
                    semester: semNum,
                  ),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              elevation: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book, size: 40, color: Color(0xFF0288D1)),
                  const SizedBox(height: 8),
                  Text(
                    'السمستر $semNum',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CoursesListScreen extends StatefulWidget {
  final String college;
  final String department;
  final int semester;

  const CoursesListScreen({
    super.key,
    required this.college,
    required this.department,
    required this.semester,
  });

  @override
  State<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends State<CoursesListScreen> {
  List<Map<String, String>> customCourses = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCourses();
  }

  String get _storageKey =>
      'courses_${widget.college}_${widget.department}_${widget.semester}';

  Future<void> _loadSavedCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data != null) {
      final List decoded = jsonDecode(data);
      setState(() {
        customCourses = decoded.map((item) => Map<String, String>.from(item)).toList();
      });
    }
  }

  Future<void> _saveCourses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(customCourses));
  }

  void _showAddCourseDialog() {
    final nameController = TextEditingController();
    final hoursController = TextEditingController();
    final labLanguagesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('إضافة مقرر جديد', textAlign: TextAlign.center),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم المقرر'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: hoursController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'عدد الساعات'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: labLanguagesController,
                decoration: const InputDecoration(
                  labelText: 'لغات المعمل (اكتب لا يوجد إن لم تتوفر)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                setState(() {
                  customCourses.add({
                    'name': nameController.text.trim(),
                    'hours': hoursController.text.trim().isEmpty
                        ? '3'
                        : hoursController.text.trim(),
                    'lab': labLanguagesController.text.trim().isEmpty
                        ? 'لا يوجد'
                        : labLanguagesController.text.trim(),
                  });
                });
                _saveCourses();
                Navigator.pop(ctx);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.department} - سمستر ${widget.semester}'),
        backgroundColor: const Color(0xFF0288D1),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0288D1),
        onPressed: _showAddCourseDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('إضافة مقرر',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: customCourses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_books, size: 70, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  const Text(
                    'لا توجد مقررات مضافة بعد.\nاضغط زر "إضافة مقرر" لإنشاء مقرر دراسي.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: customCourses.length,
              itemBuilder: (context, index) {
                final course = customCourses[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE1F5FE),
                      child: Icon(Icons.book, color: Color(0xFF0288D1)),
                    ),
                    title: Text(
                      course['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'الساعات: ${course['hours']} | لغات المعمل: ${course['lab']}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailTabbedScreen(
                            courseName: course['name']!,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
class CourseDetailTabbedScreen extends StatefulWidget {
  final String courseName;

  const CourseDetailTabbedScreen({super.key, required this.courseName});

  @override
  State<CourseDetailTabbedScreen> createState() => _CourseDetailTabbedScreenState();
}

class _CourseDetailTabbedScreenState extends State<CourseDetailTabbedScreen> {
  List<Map<String, String>> uploadedFiles = [];
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'أهلاً بك! يمكنك إدراج ملفاتك من قسم "المحاضرات" وسأقوم بإجابة استفساراتك.'
    }
  ];

  int selectedExamQuestionsCount = 5;
  String selectedQuestionType = 'اختيار من متعدد';

  @override
  void initState() {
    super.initState();
    _loadSavedFilesAndResume();
  }

  Future<void> _loadSavedFilesAndResume() async {
    final prefs = await SharedPreferences.getInstance();
    final String? filesJson = prefs.getString('files_${widget.courseName}');
    if (filesJson != null) {
      final List decoded = jsonDecode(filesJson);
      setState(() {
        uploadedFiles =
            decoded.map((e) => Map<String, String>.from(e)).toList();
      });
    }

    final int? lastPage = prefs.getInt('last_page_${widget.courseName}');
    final String? lastFile = prefs.getString('last_file_${widget.courseName}');

    if (lastPage != null && lastFile != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'تنبيه: كنت تتصفح ملف "$lastFile" عند السلايد رقم $lastPage'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'متابعة',
            onPressed: () {},
          ),
        ),
      );
    }
  }

  Future<void> _saveFiles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'files_${widget.courseName}', jsonEncode(uploadedFiles));
  }

  Future<void> _pickFileFromPhone() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        uploadedFiles.add({
          'name': result.files.single.name,
          'path': result.files.single.path!,
        });
      });
      _saveFiles();
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final query = _messageController.text;
    setState(() {
      _messages.add({'isUser': true, 'text': query});
      _messageController.clear();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        if (uploadedFiles.isEmpty) {
          _messages.add({
            'isUser': false,
            'text': 'يرجى إدراج ملفات المحاضرات أولاً ليتمكن المساعد من استخراج الإجابات.'
          });
        } else {
          _messages.add({
            'isUser': false,
            'text':
                'استناداً إلى الملف المدرج (${uploadedFiles.first['name']}): الإجابة تعتمد على شرح الشريحة الدراسية.'
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.courseName),
          backgroundColor: const Color(0xFF0288D1),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.picture_as_pdf), text: 'المحاضرات'),
              Tab(icon: Icon(Icons.chat), text: 'المحادثة'),
              Tab(icon: Icon(Icons.analytics), text: 'قياس المذاكرة'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0288D1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _pickFileFromPhone,
                    icon: const Icon(Icons.add_to_photos, color: Colors.white),
                    label: const Text(
                      'إدراج ملف محاضرة من الهاتف',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('الملفات المدرجة (${uploadedFiles.length}):',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: uploadedFiles.isEmpty
                        ? const Center(child: Text('لا توجد ملفات مدرجة'))
                        : ListView.builder(
                            itemCount: uploadedFiles.length,
                            itemBuilder: (context, index) {
                              final file = uploadedFiles[index];
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.picture_as_pdf,
                                      color: Colors.red, size: 30),
                                  title: Text(file['name']!),
                                  subtitle: const Text('اضغط للقراءة داخل التطبيق'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        uploadedFiles.removeAt(index);
                                      });
                                      _saveFiles();
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => PDFReaderScreen(
                                          filePath: file['path']!,
                                          fileName: file['name']!,
                                          courseName: widget.courseName,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg['isUser'] as bool;
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFF0288D1)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg['text'],
                            style: TextStyle(
                                color: isUser ? Colors.white : Colors.black),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                              hintText: 'اكتب سؤالك هنا...'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Color(0xFF0288D1)),
                        onPressed: _sendMessage,
                      )
                    ],
                  ),
                )
              ],
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'قياس المذاكرة واختبار المستوى',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF01579B)),
                      ),
                      const Divider(height: 25),
                      const Text('حدد عدد الأسئلة:'),
                      DropdownButtonFormField<int>(
                        value: selectedExamQuestionsCount,
                        items: [5, 10, 15]
                            .map((c) =>
                                DropdownMenuItem(value: c, child: Text('$c أسئلة')))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => selectedExamQuestionsCount = v!),
                      ),
                      const SizedBox(height: 15),
                      const Text('اختر نوع الأسئلة:'),
                      DropdownButtonFormField<String>(
                        value: selectedQuestionType,
                        items: ['اختيار من متعدد', 'صح / خطأ']
                            .map((t) =>
                                DropdownMenuItem(value: t, child: Text(t)))
                            .toList(),
                        onChanged: (v) => setState(() => selectedQuestionType = v!),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0288D1)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => QuizScreen(
                                  questionCount: selectedExamQuestionsCount,
                                  courseName: widget.courseName,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_arrow, color: Colors.white),
                          label: const Text('بدء قياس المذاكرة الآن',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFReaderScreen extends StatefulWidget {
  final String filePath;
  final String fileName;
  final String courseName;

  const PDFReaderScreen({
    super.key,
    required this.filePath,
    required this.fileName,
    required this.courseName,
  });

  @override
  State<PDFReaderScreen> createState() => _PDFReaderScreenState();
}

class _PDFReaderScreenState extends State<PDFReaderScreen> {
  int currentPage = 0;

  Future<void> _saveCurrentPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_page_${widget.courseName}', page + 1);
    await prefs.setString('last_file_${widget.courseName}', widget.fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.fileName} (سلايد ${currentPage + 1})'),
        backgroundColor: const Color(0xFF0288D1),
        foregroundColor: Colors.white,
      ),
      body: PDFView(
        filePath: widget.filePath,
        onPageChanged: (page, total) {
          if (page != null) {
            setState(() {
              currentPage = page;
            });
            _saveCurrentPage(page);
          }
        },
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final int questionCount;
  final String courseName;

  const QuizScreen(
      {super.key, required this.questionCount, required this.courseName});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختبار: ${widget.courseName}'),
        backgroundColor: const Color(0xFF0288D1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('سؤال تجريبي لتحديد المستوى (${widget.questionCount} أسئلة)'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                int finalScore = 80;
                String reviewText =
                    'نتائج قياس المذاكرة لـ ${widget.courseName}:\n'
                    'نسبة النجاح: $finalScore%\n'
                    'س1: مفهوم النظام - الإجابة: صحيح\n'
                    'س2: معالجة البيانات - الإجابة: صحيح';

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => ResultScreen(
                      score: finalScore,
                      reviewText: reviewText,
                    ),
                  ),
                );
              },
              child: const Text('إنهاء الاختبار واحتساب النتيجة'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final String reviewText;

  const ResultScreen(
      {super.key, required this.score, required this.reviewText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نتيجة قياس المذاكرة'),
        backgroundColor: const Color(0xFF0288D1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'نسبة النجاح: $score%',
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.grey.shade100,
                child: SingleChildScrollView(
                  child: Text(reviewText),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: reviewText));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم نسخ الإجابات والنتائج!')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('نسخ النسخة'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Share.share(reviewText);
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('مشاركة'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
