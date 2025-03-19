// widgets/search_bar_widget.dart
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBarWidget extends StatelessWidget {
  final Function()? onTunePressed;
  
  const SearchBarWidget({
    super.key,
    this.onTunePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade300),
              color: pureWhite,
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Find your lesson',
                      hintStyle: GoogleFonts.montserrat(color: Colors.grey.shade500),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        
        // Separator
        const SizedBox(width: 12),
        
        // Tune button as separate element
        Container(
          
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: onTunePressed,
            child: const Icon(Icons.tune, color: Colors.lightBlue),
          ),
        ),
      ],
    );
  }
}