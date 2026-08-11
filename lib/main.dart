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
              title: Text(college['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('التخصصات: ${(college['departments'] as List).length}'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DepartmentsScreen(
                    collegeName: college['name'], departments: List<String>.from(college['departments']))));
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
  const DepartmentsScreen({super.key, required this.collegeName, required this.departments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(collegeName), backgroundColor: const Color(0xFF0288D1), foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: departments.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text(departments[index]),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SemestersScreen(college: collegeName, department: departments[index]))),
          ),
        ),
      ),
    );
  }
}
class SemestersScreen extends StatelessWidget {
  final String college;
  final String department;
  const SemestersScreen({super.key, required this.college, required this.department});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('السمستر - $department'), backgroundColor: const Color(0xFF0288D1), foregroundColor: Colors.white),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: 10,
        itemBuilder: (context, index) => Card(
          child: InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CoursesListScreen(college: college, department: department, semester: index + 1))),
            child: Center(child: Text('السمستر ${index + 1}')),
          ),
        ),
      ),
    );
  }
}

class CoursesListScreen extends StatefulWidget {
  final String college; final String department; final int semester;
  const CoursesListScreen({super.key, required this.college, required this.department, required this.semester});
  @override
  State<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends State<CoursesListScreen> {
  List<Map<String, String>> customCourses = [];
  @override
  void initState() { super.initState(); _loadSavedCourses(); }
  
  String get _storageKey => 'courses_${widget.college}_${widget.department}_${widget.semester}';
  
  Future<void> _loadSavedCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data != null) setState(() { customCourses = (jsonDecode(data) as List).map((e) => Map<String, String>.from(e)).toList(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.department} - سمستر ${widget.semester}'), backgroundColor: const Color(0xFF0288D1), foregroundColor: Colors.white),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)), // أضيفي منطق الحوار هنا
      body: ListView.builder(itemCount: customCourses.length, itemBuilder: (context, index) => ListTile(title: Text(customCourses[index]['name']!), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailTabbedScreen(courseName: customCourses[index]['name']!))))),
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
    {'isUser': false, 'text': 'أهلاً بك! يمكنك إدراج ملفاتك من قسم "المحاضرات" وسأقوم بمساعدتك.'}
  ];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final String? filesJson = prefs.getString('files_${widget.courseName}');
    if (filesJson != null) {
      setState(() {
        uploadedFiles = (jsonDecode(filesJson) as List).map((e) => Map<String, String>.from(e)).toList();
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        uploadedFiles.add({'name': result.files.single.name, 'path': result.files.single.path!});
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('files_${widget.courseName}', jsonEncode(uploadedFiles));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.courseName), backgroundColor: const Color(0xFF0288D1), foregroundColor: Colors.white,
          bottom: const TabBar(tabs: [Tab(icon: Icon(Icons.picture_as_pdf), text: 'المحاضرات'), Tab(icon: Icon(Icons.chat), text: 'المحادثة'), Tab(icon: Icon(Icons.analytics), text: 'الاختبار')]),
        ),
        body: TabBarView(children: [
          // تبويب المحاضرات
          ListView.builder(itemCount: uploadedFiles.length + 1, itemBuilder: (context, index) {
            if (index == 0) return ListTile(leading: const Icon(Icons.add), title: const Text('إضافة ملف PDF'), onTap: _pickFile);
            final file = uploadedFiles[index - 1];
            return ListTile(title: Text(file['name']!), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => PDFReaderScreen(filePath: file['path']!, fileName: file['name']!, courseName: widget.courseName))));
          }),
          // تبويب المحادثة
          Column(children: [
            Expanded(child: ListView.builder(itemCount: _messages.length, itemBuilder: (c, i) => Text(_messages[i]['text']))),
            TextField(controller: _messageController, decoration: const InputDecoration(hintText: 'اسأل هنا...'))
          ]),
          // تبويب الاختبار
          Center(child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => QuizScreen(courseName: widget.courseName))), child: const Text('ابدأ الاختبار')))
        ]),
      ),
    );
  }
}

class PDFReaderScreen extends StatelessWidget {
  final String filePath, fileName, courseName;
  const PDFReaderScreen({super.key, required this.filePath, required this.fileName, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(fileName)), body: PDFView(filePath: filePath));
  }
}

class QuizScreen extends StatelessWidget {
  final String courseName;
  const QuizScreen({super.key, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('الاختبار')), body: Center(child: ElevatedButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const ResultScreen(score: 85, reviewText: 'أحسنت! مستوى جيد.'))), child: const Text('إنهاء'))));
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final String reviewText;
  const ResultScreen({super.key, required this.score, required this.reviewText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('النتيجة')), body: Center(child: Column(children: [Text('النتيجة: $score%'), Text(reviewText), ElevatedButton(onPressed: () => Share.share(reviewText), child: const Text('مشاركة'))])));
  }
}
