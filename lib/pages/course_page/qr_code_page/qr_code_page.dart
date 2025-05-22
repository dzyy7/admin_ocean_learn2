import 'dart:convert';
import 'package:admin_ocean_learn2/model/course_model.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatelessWidget {
  final CourseModel course;

  const QRCodePage({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String qrDecodedData = '';
    
    if (course.qrCode != null) {
      try {
        qrDecodedData = utf8.decode(base64.decode(course.qrCode!));
      } catch (e) {
        qrDecodedData = course.qrCode!;
      }
    }

    String expiryText = 'No expiration';
    Color expiryColor = Colors.black54;
    
    if (course.qrEndDate != null) {
      final now = DateTime.now();
      if (course.qrEndDate!.isAfter(now)) {
        final difference = course.qrEndDate!.difference(now);
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
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
                    course.title,
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
          ],
        ),
      ),
    );
  }
}