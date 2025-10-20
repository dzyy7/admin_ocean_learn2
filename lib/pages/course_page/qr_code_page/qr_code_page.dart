import 'dart:convert';
import 'dart:ui';
import 'package:admin_ocean_learn2/model/attendance_model.dart';
import 'package:admin_ocean_learn2/model/course_model.dart';
import 'package:admin_ocean_learn2/services/attendance_service.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class QRCodePage extends StatefulWidget {
  final CourseModel course;

  const QRCodePage({super.key, required this.course});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  AttendanceResponseModel? attendanceData;
  bool isLoadingAttendance = true;

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    setState(() {
      isLoadingAttendance = true;
    });

    try {
      final attendance =
          await AttendanceService.getAttendance(widget.course.id);
      setState(() {
        attendanceData = attendance;
        isLoadingAttendance = false;
      });
    } catch (e) {
      print('Error loading attendance: $e');
    }
  }

  // Method untuk menentukan status QR Code berdasarkan waktu
  Map<String, dynamic> _getQRStatus() {
    final now = DateTime.now();
    final classDate = widget.course.date; // class_date
    final endDate = widget.course.qrEndDate; // end_at
    
    bool isLocked = true;
    String statusText = 'QR Code not available';
    Color statusColor = Colors.grey;
    
    if (endDate != null) {
      if (now.isBefore(classDate)) {
        // Sebelum class_date - QR terkunci
        final difference = classDate.difference(now);
        if (difference.inDays > 0) {
          statusText = 'QR will open in ${difference.inDays} days';
        } else if (difference.inHours > 0) {
          statusText = 'QR will open in ${difference.inHours} hours';
        } else {
          statusText = 'QR will open in ${difference.inMinutes} minutes';
        }
        statusColor = Colors.orange;
        isLocked = true;
      } else if (now.isAfter(classDate) && now.isBefore(endDate)) {
        // Antara class_date dan end_at - QR terbuka
        final difference = endDate.difference(now);
        if (difference.inHours > 0) {
          statusText = 'QR active - expires in ${difference.inHours} hours';
        } else {
          statusText = 'QR active - expires in ${difference.inMinutes} minutes';
        }
        statusColor = Colors.green;
        isLocked = false;
      } else {
        // Setelah end_at - QR terkunci lagi
        statusText = 'QR Code has expired';
        statusColor = Colors.red;
        isLocked = true;
      }
    } else {
      // Fallback jika tidak ada end_at
      if (now.isAfter(classDate)) {
        statusText = 'QR Code is active';
        statusColor = Colors.green;
        isLocked = false;
      } else {
        final difference = classDate.difference(now);
        if (difference.inDays > 0) {
          statusText = 'QR will open in ${difference.inDays} days';
        } else if (difference.inHours > 0) {
          statusText = 'QR will open in ${difference.inHours} hours';
        } else {
          statusText = 'QR will open in ${difference.inMinutes} minutes';
        }
        statusColor = Colors.orange;
        isLocked = true;
      }
    }
    
    return {
      'isLocked': isLocked,
      'statusText': statusText,
      'statusColor': statusColor,
    };
  }

  @override
  Widget build(BuildContext context) {
    String qrDecodedData = '';

    if (widget.course.qrCode != null) {
      try {
        qrDecodedData = utf8.decode(base64.decode(widget.course.qrCode!));
      } catch (e) {
        qrDecodedData = widget.course.qrCode!;
      }
    }

    // Mendapatkan status QR Code
    final qrStatus = _getQRStatus();
    final bool isLocked = qrStatus['isLocked'];
    final String statusText = qrStatus['statusText'];
    final Color statusColor = qrStatus['statusColor'];

    return Scaffold(
      backgroundColor: netralColor,
      appBar: AppBar(
        backgroundColor: netralColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Course QR Code",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadAttendanceData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.course.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Menampilkan informasi jadwal kelas
                  Text(
                    'Class: ${DateFormat('dd MMM yyyy, HH:mm').format(widget.course.date)}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (widget.course.qrEndDate != null)
                    Text(
                      'End: ${DateFormat('dd MMM yyyy, HH:mm').format(widget.course.qrEndDate!)}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (qrDecodedData.isNotEmpty)
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        QrImageView(
                          data: qrDecodedData,
                          version: QrVersions.auto,
                          size: 200.0,
                          backgroundColor: Colors.white,
                        ),
                        if (isLocked)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                width: 200,
                                height: 200,
                                color: Colors.black.withOpacity(0.2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'LOCKED',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    )
                  else
                    Text(
                      'No QR code available for this course',
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isLocked ? Icons.lock : Icons.lock_open,
                          size: 16,
                          color: statusColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusText,
                          style: GoogleFonts.poppins(
                            color: statusColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.people_outline,
                        color: primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Attendance List',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  if (attendanceData?.date.isNotEmpty == true) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Last updated: ${_formatDate(attendanceData!.date)}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (isLoadingAttendance)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (attendanceData == null || !attendanceData!.status)
                    Center(
                      child: Text(
                        'No attendance records yet',
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 150, 150, 150),
                          fontSize: 14,
                        ),
                      ),
                    )
                  else if (attendanceData!.data.isEmpty)
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_off_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No attendance records yet',
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Present:',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '${attendanceData!.data.length}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: attendanceData!.data.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final attendance = attendanceData!.data[index];
                            return _buildAttendanceItem(attendance, index + 1);
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceItem(AttendanceModel attendance, int number) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '$number',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attendance.userName ?? 'Unknown User',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Attended at ${_formatTime(attendance.attendanceTime)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  attendance.status == 'present' ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              attendance.status.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }
}