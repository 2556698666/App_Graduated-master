import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:app/Config/api_config.dart';

import 'home_page.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({super.key});

  @override
  State<CreateClass> createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  String teacherName = '';
  bool isLoading = true;
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  int? createdClassId;

  @override
  void initState() {
    super.initState();
    fetchTeacherName();
  }

  Future<void> fetchTeacherName() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    final response = await http.get(
      Uri.parse('$baseUrl/api/profile')
      ,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        teacherName = data['name'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> createClass() async {
    final subject = subjectController.text.trim();
    final grade = gradeController.text.trim();
    if (subject.isEmpty || grade.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subject and Grade cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    final gradeResponse = await http.post(
      Uri.parse('$baseUrl/api/grades?name=$grade')
      ,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (gradeResponse.statusCode != 200 && gradeResponse.statusCode != 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create grade'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final gradeData = jsonDecode(gradeResponse.body);
    final gradeId = gradeData['id'].toString();

    final classResponse = await http.post(
      Uri.parse('$baseUrl/api/classes?name=$subject&grade_id=$gradeId'),

      headers: {'Authorization': 'Bearer $token'},
    );

    if (classResponse.statusCode == 200 || classResponse.statusCode == 201) {
      final classData = jsonDecode(classResponse.body);
      createdClassId = classData['id'];

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Class created successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create class'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showStudentSheet(BuildContext context) {
    final idController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add New Student",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: "Student ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString('token');
                    final studentId = idController.text.trim();

                    if (studentId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter student ID'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (token != null) {
                      final url = Uri.parse('$baseUrl/api/classes/15/students?student_id=$studentId')
                      ;
                      final response = await http.post(
                        url,
                        headers: {
                          'Authorization': 'Bearer $token',
                          'Accept': 'application/json',
                          'Content-Type': 'application/json',
                        },
                      );

                      Navigator.pop(context);
                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Student added successfully'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to add student'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text("Add Student"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showBookSheet(BuildContext context) {
    Future<bool> requestStoragePermission() async {
      var status = await Permission.storage.request();
      return status.isGranted;
    }
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String? filePath;
    List<int>? fileBytes;
    String? fileName;
    showModalBottomSheet(
      context: context,
      builder:
          (_) => StatefulBuilder(
        builder:
            (context, setModalState) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add New Task",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    filePath == null
                        ? "No file selected"
                        : "PDF Selected ✅",
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final hasPermission = await requestStoragePermission();
                        if (!hasPermission) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("You must allow storage access to upload the file."),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );

                        if (result != null) {
                          setModalState(() {
                            filePath = result.files.single.path;
                            fileBytes = result.files.single.bytes;
                            fileName = result.files.single.name;
                          });
                        }
                      },
                    child: const Text("Upload PDF"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final prefs =
                      await SharedPreferences.getInstance();
                      final token = prefs.getString('token');
                      if (token != null) {
                        final uri = Uri.parse("$baseUrl/api/tasks")
                        ;
                        var request = http.MultipartRequest(
                          'POST',
                          uri,
                        );
                        request.headers['Authorization'] =
                        'Bearer $token';
                        request.fields['title'] = titleController.text;
                        request.fields['description'] =
                            descController.text;
                        if (createdClassId != null) {
                          request.fields['class_id'] = createdClassId.toString();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("❌ Please create a class first."),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        if (filePath != null) {
                          if (kIsWeb &&
                              fileBytes != null &&
                              fileName != null) {
                            request.files.add(
                              http.MultipartFile.fromBytes(
                                'file',
                                fileBytes!,
                                filename: fileName,
                              ),
                            );
                          } else {
                            request.files.add(
                              await http.MultipartFile.fromPath(
                                'file',
                                filePath!,
                              ),
                            );
                          }
                        }
                        final response = await request.send();
                        final resBody =
                        await response.stream.bytesToString();
                        Navigator.pop(context);
                        print(
                          "📦 Status Code: \${response.statusCode}",
                        );
                        print("📦 Response Body: $resBody");
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                '✅ Task added successfully',
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '❌ Failed to add Task\n$resBody',
                              ),

                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text("Add Task"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showTaskSheet(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffef8ff),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
        ),
        title: const Text('Back', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: createClass,
                    child: buildRoundedButton("Create Class"),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: 180,
                      child: TextField(
                        controller: subjectController,
                        decoration: InputDecoration(
                          hintText: "Subject Name",
                          filled: true,
                          fillColor: const Color(0xff1265ae),
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 160,
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(text: teacherName),
                    decoration: InputDecoration(
                      hintText: "Teacher",
                      filled: true,
                      fillColor: const Color(0xff1265ae),
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: TextField(
                    controller: gradeController,
                    decoration: InputDecoration(
                      hintText: "Grade",
                      filled: true,
                      fillColor: const Color(0xff1265ae),
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            buildActionRow(context, "Add Students", showStudentSheet),
            const SizedBox(height: 20),
            buildActionRow(context, "Add Task", showBookSheet),
            const SizedBox(height: 20),
            buildActionRow(context, "Add Book",addbooktask),

          ],
        ),
      ),
    );
  }
  void addbooktask(BuildContext context){}
  Widget buildRoundedButton(String label, {EdgeInsets? padding}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff1265ae),
        borderRadius: BorderRadius.circular(24),
      ),
      padding:
      padding ?? const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget buildActionRow(
      BuildContext context,
      String title,
      Function(BuildContext) onPressed,
      ) {
    return Row(
      children: [
        Expanded(
          child: buildRoundedButton(
            title,
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => onPressed(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xffe0eafc),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, size: 24),
          ),
        ),
      ],
    );
  }
}
