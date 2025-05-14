import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({super.key});

  @override
  State<CreateClass> createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  String teacherName = '';
  bool isLoading = true;

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
      Uri.parse('http://school_mangment.test/api/profile'),
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

  void showStudentSheet(BuildContext context) {
    final idController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add New Student", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 12),
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: "Student ID", border: OutlineInputBorder()),
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
                        const SnackBar(content: Text('Please enter student ID'), backgroundColor: Colors.red),
                      );
                      return;
                    }

                    if (token != null) {
                      final url = Uri.parse('http://school_mangment.test/api/classes/5/students?student_id=$studentId');
                      final response = await http.post(
                        url,
                        headers: {
                          'Authorization': 'Bearer $token',
                          'Accept': 'application/json',
                          'Content-Type': 'application/json',
                        },
                      );

                      print('Status: ${response.statusCode}');
                      print('Body: ${response.body}');

                      Navigator.pop(context);
                      if (response.statusCode == 200 || response.statusCode == 201) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Student added successfully')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to add student'), backgroundColor: Colors.red),
                        );
                      }
                    }
                  },
                  child: const Text("Add Student"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void showBookSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add New Book", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Grade:"),
                ElevatedButton(
                  onPressed: () async {
                    await FilePicker.platform.pickFiles();
                  },
                  child: const Text("Upload PDF"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Add Book")),
              ],
            )
          ],
        ),
      ),
    );
  }

  void showTaskSheet(BuildContext context) {
    final nameController = TextEditingController();
    final titleController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add New Task", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 12),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Grade:"),
                ElevatedButton(onPressed: () async {
                  await FilePicker.platform.pickFiles();
                }, child: const Text("Upload PDF")),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Add Task")),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffef8ff),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Back', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  buildRoundedButton("Create Class"),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: 180,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Class Name",
                          filled: true,
                          fillColor: const Color(0xff1265ae),
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                buildRoundedButton("Subject", padding: const EdgeInsets.symmetric(horizontal: 20)),
              ],
            ),
            const SizedBox(height: 30),
            buildActionRow(context, "Add Students", showStudentSheet),
            const SizedBox(height: 20),
            buildActionRow(context, "Add books", showBookSheet),
            const SizedBox(height: 20),
            buildActionRow(context, "Add Tasks", showTaskSheet),
          ],
        ),
      ),
    );
  }

  Widget buildRoundedButton(String label, {EdgeInsets? padding}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff1265ae),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  Widget buildActionRow(BuildContext context, String title, Function(BuildContext) onPressed) {
    return Row(
      children: [
        Expanded(child: buildRoundedButton(title, padding: const EdgeInsets.symmetric(vertical: 18))),
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
