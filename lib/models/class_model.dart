class ClassModel {
  final int id;
  final String name;
  final int teacherId;
  final int gradeId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClassModel({
    required this.id,
    required this.name,
    required this.teacherId,
    required this.gradeId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      name: json['name'],
      teacherId: json['teacher_id'],
      gradeId: int.parse(json['grade_id'].toString()),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
