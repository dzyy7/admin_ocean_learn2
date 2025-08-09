import 'dart:convert';
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

  const QRCodePage({Key? key, required this.course}) : super(key: key);

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
      final attendance = await AttendanceService.getAttendance(widget.course.id);
      setState(() {
        attendanceData = attendance;
        isLoadingAttendance = false;
      });
    } catch (e) {
      setState(() {
        isLoadingAttendance = false;
      });
      print('Error loading attendance: $e');
    }
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

    String expiryText = 'No expiration';
    Color expiryColor = Colors.black54;
    
    if (widget.course.qrEndDate != null) {
      final now = DateTime.now();
      if (widget.course.qrEndDate!.isAfter(now)) {
        final difference = widget.course.qrEndDate!.difference(now);
        if (difference.inDays > 0) {
          expiryText = 'Expires in ${difference.inDays} days';
        } else if (difference.inHours > 0) {
          expiryText = 'Expires in ${difference.inHours} hours';
        } else {
          expiryText = 'Expires in ${difference.inMinutes} minutes';
        }
        expiryColor = Colors.green;
      } else {
        expiryText = 'QR Code has expired';
        expiryColor = Colors.red;
      }
    }

    return Scaffold(
      backgroundColor: netralColor,
      appBar: AppBar(
        backgroundColor: netralColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Course QR Code",
          style: const TextStyle(
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
            // QR Code Section
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
                  const SizedBox(height: 24),
                  if (qrDecodedData.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child: QrImageView(
                        data: qrDecodedData,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
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
                  Text(
                    expiryText,
                    style: GoogleFonts.poppins(
                      color: expiryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Attendance List Section
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
                      Icon(
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
                        // Summary
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
                        
                        // Attendance List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: attendanceData!.data.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
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
          // Number
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
          
          // User Info
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
              color: attendance.status == 'present' ? Colors.green : Colors.orange,
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