class CourseModel {
  String id;
  String title;
  String description;
  String url;
  DateTime date;
  String note;
  DateTime? releaseAt;
  String? qrCode;
  DateTime? endAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.date,
    this.note = "",
    this.releaseAt,
    this.qrCode,
    this.endAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'date': date.millisecondsSinceEpoch,
      'note': note,
      'releaseAt': releaseAt?.millisecondsSinceEpoch,
      'qrCode': qrCode,
      'endAt': endAt?.millisecondsSinceEpoch,
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
      releaseAt: map['releaseAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['releaseAt'])
          : null,
      qrCode: map['qrCode'],
      endAt: map['endAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endAt'])
          : null,
    );
  }

  // New method to create from API JSON
  factory CourseModel.fromApiJson(Map<String, dynamic> json) {
    // Handle the nested structure from API
    return CourseModel(
      id: json['id'].toString(),
      title: json['data']?['title'] ?? "",
      description: json['data']?['description'] ?? "",
      url: json['data']?['video_url'] ?? "",
      date: json['date']?['class_date'] != null
          ? DateTime.parse(json['date']['class_date'])
          : DateTime.now(),
      releaseAt: json['date']?['release_at'] != null
          ? DateTime.parse(json['date']['release_at'])
          : null,
      qrCode: json['qr_data']?['qr_code'],
      endAt: json['qr_data']?['end_at'] != null
          ? DateTime.parse(json['qr_data']['end_at'])
          : null,
      note: json['data']?['note'] ?? "",
    );
  }
}