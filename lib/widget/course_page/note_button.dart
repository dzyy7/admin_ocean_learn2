import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NoteButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        height: 47, // Fixed height for better control
        decoration: BoxDecoration(
          color: secondaryColor, 
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryColor, width: 1.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onPressed,
            child: Center(
              child: Text(
                "I want to write a note!",
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
