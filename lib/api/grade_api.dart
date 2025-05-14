
import 'package:http/http.dart' as http;
import 'dart:convert';

class GradeApi {
  static const String _baseUrl = 'http://school_mangment.test/api';

  static Future<List<Map<String, dynamic>>> fetchGrades() async {
    final url = Uri.parse('$_baseUrl/grades');
    final response = await http.get(url);


    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load grades');
    }
  }
}
