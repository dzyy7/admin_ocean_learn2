import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/color_palette.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: Image.asset(
              'assets/images/logo_light.png',
              errorBuilder: (ctx, err, st) => Icon(
                Icons.school,
                size: 40,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ocean Learn',
            style: GoogleFonts.montserrat(
              fontSize: 20, fontWeight: FontWeight.bold, color: textColor,
            ),
          ),
          Text(
            'Dive into learning, as deep as the sea.',
            style: GoogleFonts.montserrat(
              fontSize: 12, color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
