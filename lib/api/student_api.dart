import 'package:http/http.dart' as http;

Future<bool> addStudentToClass(int classId, int studentId) async {
  final url = Uri.parse('http://school_mangment.test/api/classes/$classId/students?student_id=$studentId');

  final response = await http.post(url);

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("✅ Student added successfully");
    return true;
  } else {
    print("❌ Error: ${response.body}");
    return false;
  }
}
