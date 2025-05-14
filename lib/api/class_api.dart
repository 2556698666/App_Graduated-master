import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/class_model.dart';

Future<ClassModel?> createClass(String name, int gradeId, int teacherId) async {
  final url = Uri.parse('http://school_mangment.test/api/classes');

  final response = await http.post(
    url,
    body: {
      'name': name,
      'grade_id': gradeId.toString(),
      'teacher_id': teacherId.toString(),
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = jsonDecode(response.body);
    return ClassModel.fromJson(data);
  } else {
    print('Error: ${response.body}');
    return null;
  }
}
