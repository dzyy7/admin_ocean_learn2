class AttendanceResponseModel {
  final bool status;
  final String date;
  final List<AttendanceModel> data;

  AttendanceResponseModel({
    required this.status,
    required this.date,
    required this.data,
  });

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    return AttendanceResponseModel(
      status: json['status'] ?? false,
      date: json['date'] ?? '',
      data: json['data'] != null
          ? List<AttendanceModel>.from(json['data'].map((x) => AttendanceModel.fromJson(x)))
          : [],
    );
  }
}

class AttendanceModel {
  final int id;
  final String status;
  final int userId;
  final int courseId;
  final String attendanceTime;
  String? userName; // Will be populated from member data

  AttendanceModel({
    required this.id,
    required this.status,
    required this.userId,
    required this.courseId,
    required this.attendanceTime,
    this.userName,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      userId: json['user_id'] ?? 0,
      courseId: json['course_id'] ?? 0,
      attendanceTime: json['attendance_time'] ?? '',
    );
  }
}