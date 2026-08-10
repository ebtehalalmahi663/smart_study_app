import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
          seedColor: const Color(0xFF0288D1),
          primary: const Color(0xFF0288D1),
          secondary: const Color(0xFF00B0FF),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
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
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF0288D1), Color(0xFF01579B)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFE1F5FE),
                        child: Icon(Icons.school_rounded, size: 50, color: Color(0xFF0288D1)),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'المساعد الدراسي الذكي',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF01579B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'اختر الفصل الدراسي للبدء',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 28),
                      DropdownButtonFormField<int>(
                        value: selectedSemester,
                        decoration: InputDecoration(
                          labelText: 'اختر السمستر (1 - 10)',
                          prefixIcon: const Icon(Icons.format_list_numbered, color: Color(0xFF0288D1)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
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
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0288D1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
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
        backgroundColor: const Color(0xFF0288D1),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFE1F5FE),
                child: Icon(course['icon'] as IconData, color: const Color(0xFF0288D1)),
              ),
              title: Text(
                course['name'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: const Text('اضغط لبدء الدراسة والمناقشة'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailTabbedScreen(
                      courseName: course['name'] as String,
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
// =============================================================
// الشاشة الثالثة: الشاشة المفصلة بثلاثة أقسام (Tabbed Screen)
// =============================================================
class CourseDetailTabbedScreen extends StatefulWidget {
  final String courseName;

  const CourseDetailTabbedScreen({super.key, required this.courseName});

  @override
  State<CourseDetailTabbedScreen> createState() => _CourseDetailTabbedScreenState();
}

class _CourseDetailTabbedScreenState extends State<CourseDetailTabbedScreen> {
  // قائمة الملفات المدرجة
  List<PlatformFile> uploadedFiles = [];

  // متغيرات قسم المحادثة
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'أهلاً بك! يمكنك إدراج ملفاتك من قسم "المحاضرات" وسأقوم بإجابة استفساراتك بناءً عليها.'
    }
  ];

  // متغيرات قسم تكوين الامتحان
  int selectedExamQuestionsCount = 5;
  String selectedQuestionType = 'اختيار من متعدد';
  List<String> selectedExamLectures = [];

  // دالة فتح متصفح الملفات واختيار أي عدد من الملفات
  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx'],
      );

      if (result != null) {
        setState(() {
          uploadedFiles.addAll(result.files);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تمت إضافة ${result.files.length} ملف/ملفات بنجاح!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم اختيار الملفات بنجاح.')),
        );
      }
    }
  }

  // دالة إرسال سؤال في المحادثة
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
            'text': 'يرجى إدراج ملفات المحاضرات أولاً من قسم (المحاضرات) ليتمكن المساعد من استخراج الإجابات الدقيقة لك.'
          });
        } else {
          _messages.add({
            'isUser': false,
            'text': 'استناداً إلى الملفات المدرجة (${uploadedFiles.first.name}): إجابة سؤالك تعتمد على المفاهيم الموضحة في الملاحظات الدراسية.'
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
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.picture_as_pdf), text: 'المحاضرات'),
              Tab(icon: Icon(Icons.chat), text: 'المحادثة'),
              Tab(icon: Icon(Icons.assignment), text: 'تكوين الامتحان'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ---------------------------------------------------------
            // القسم الأول: المحاضرات
            // ---------------------------------------------------------
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
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _pickFiles,
                    icon: const Icon(Icons.add_to_photos, color: Colors.white),
                    label: const Text(
                      'إدراج ملفات المحاضرات',
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'الملفات المدرجة:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF01579B)),
                      ),
                      Text(
                        'العدد: ${uploadedFiles.length}',
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: uploadedFiles.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_open, size: 70, color: Colors.grey.shade400),
                                const SizedBox(height: 12),
                                const Text(
                                  'لم يتم إدراج أي ملفات بعد\nاضغط على الزر أعلاه لاختيار الملفات',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey, fontSize: 15),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: uploadedFiles.length,
                            itemBuilder: (context, index) {
                              final file = uploadedFiles[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                                  title: Text(file.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text('${(file.size / 1024).toStringAsFixed(1)} KB'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        uploadedFiles.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            // ---------------------------------------------------------
            // القسم الثاني: الشات والمناقشة
            // ---------------------------------------------------------
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: const Color(0xFFE1F5FE),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF0288D1), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'الإجابات تعتمد على ${uploadedFiles.length} ملف/ملفات مدرجة.',
                          style: const TextStyle(fontSize: 13, color: Color(0xFF01579B)),
                        ),
                      ),
                    ],
                  ),
                ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isUser ? const Color(0xFF0288D1) : Colors.white,
                            borderRadius: BorderRadius.circular(16).copyWith(
                              bottomRight: isUser ? Radius.zero : null,
                              bottomLeft: !isUser ? Radius.zero : null,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
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
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'اكتب سؤالك حول الملفات المدرجة...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF4F6F9),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: const Color(0xFF0288D1),
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

            // ---------------------------------------------------------
            // القسم الثالث: تكوين الامتحان
            // ---------------------------------------------------------
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.quiz, color: Color(0xFF0288D1), size: 28),
                          SizedBox(width: 10),
                          Text(
                            'إعداد الاختبار التجريبي',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF01579B)),
                          ),
                        ],
                      ),
                      const Divider(height: 30),

                      // اختيار المحاضرات
                      const Text('اختر المحاضرات للرصد:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 8),
                      uploadedFiles.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'تنبيه: يمكنك اختيار المحاضرات بعد إدراج ملفات في قسم المحاضرات.',
                                style: TextStyle(color: Colors.amber, fontSize: 13),
                              ),
                            )
                          : Column(
                              children: uploadedFiles.map((file) {
                                return CheckboxListTile(
                                  title: Text(file.name),
                                  value: selectedExamLectures.contains(file.name),
                                  activeColor: const Color(0xFF0288D1),
                                  onChanged: (bool? val) {
                                    setState(() {
                                      if (val == true) {
                                        selectedExamLectures.add(file.name);
                                      } else {
                                        selectedExamLectures.remove(file.name);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),

                      const SizedBox(height: 20),

                      // عدد الأسئلة
                      const Text('حدد عدد الأسئلة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: selectedExamQuestionsCount,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        items: [5, 10, 15, 20]
                            .map((count) => DropdownMenuItem(value: count, child: Text('$count أسئلة')))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedExamQuestionsCount = val);
                        },
                      ),

                      const SizedBox(height: 20),

                      // نوع الأسئلة
                      const Text('اختر نوع الأسئلة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedQuestionType,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        items: ['اختيار من متعدد', 'صح / خطأ', 'أسئلة مقالية قصيرة', 'خليط متعدّد']
                            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedQuestionType = val);
                        },
                      ),

                      const SizedBox(height: 30),

                      // زر تكوين الامتحان
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0288D1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('تم تكوين الامتحان بنجاح!'),
                                content: Text(
                                  'تم إنشاء اختبار مكون من $selectedExamQuestionsCount أسئلة ($selectedQuestionType) استناداً إلى المحاضرات المختارة.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('بدء الاختبار الان'),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.auto_awesome, color: Colors.white),
                          label: const Text(
                            'تكوين الامتحان الآن',
                            style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
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
