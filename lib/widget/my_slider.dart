import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
class MySlider extends StatelessWidget {
  final String img;
  final String title;
  final String description;

  const MySlider({
    Key? key,
    required this.img,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            img,
            height: 300,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
