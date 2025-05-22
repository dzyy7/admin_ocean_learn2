class CourseModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final DateTime date;
  final String? qrCode;
  final DateTime? qrEndDate;
  String note;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.date,
    this.qrCode,
    this.qrEndDate,
    this.note = '',
  });

  factory CourseModel.fromApiJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final dateData = json['date'] ?? {};
    final qrData = json['qr_data'] ?? {};
    
    return CourseModel(
      id: json['id'].toString(),
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      videoUrl: data['video_url'] ?? '',
      date: DateTime.tryParse(dateData['class_date'] ?? '') ?? DateTime.now(),
      qrCode: qrData['qr_code'],
      qrEndDate: DateTime.tryParse(qrData['end_at'] ?? ''),
      note: data['note'] ?? '',
    );
  }
}