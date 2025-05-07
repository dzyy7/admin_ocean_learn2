import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyText extends StatelessWidget {
  final String text;
  final double fontsize;
  final String fontfamily;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;

  const MyText({
    Key? key,
    required this.text,
    required this.fontsize,
    required this.fontfamily,
    required this.fontWeight,
    required this.color,
    required this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      text,
      style: GoogleFonts.poppins(
        fontWeight: fontWeight,
        fontSize: fontsize,
        color: color,
      ),
    );
  }
}
