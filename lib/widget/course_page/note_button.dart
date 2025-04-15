import 'package:flutter/material.dart';

class NoteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NoteButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("I want to write a note!", style: TextStyle(color: Colors.black87)),
      ),
    );
  }
}
