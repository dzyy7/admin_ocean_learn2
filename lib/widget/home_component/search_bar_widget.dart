// widgets/search_bar_widget.dart
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String)? onChanged;
  final Function()? onTunePressed;
  final bool isNewest; // new

  const SearchBarWidget({
    super.key,
    this.onChanged,
    this.onTunePressed,
    required this.isNewest,
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
                    onChanged: onChanged,
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
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: onTunePressed,
            child: Icon(
              isNewest ? Icons.arrow_downward : Icons.arrow_upward,
              color: Colors.lightBlue,
            ),
          ),
        ),
      ],
    );
  }
}
