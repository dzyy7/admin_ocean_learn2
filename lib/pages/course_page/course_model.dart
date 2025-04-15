// models/course_model.dart
class CourseModel {
  String id;
  String title;
  String description;
  String url;
  DateTime date;
  String note; // Single string for note

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.date,
    this.note = "", // Default empty note
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'date': date.millisecondsSinceEpoch,
      'note': note,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      url: map['url'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      note: map['note'] ?? "",
    );
  }
}