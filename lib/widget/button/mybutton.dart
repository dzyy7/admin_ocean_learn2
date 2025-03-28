import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final BoxBorder? border;
  
  const MyButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.borderRadius,
    this.backgroundColor = const Color(0xFFE6F7FD),
    this.textColor = const Color(0xFF333333),
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w500,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : BorderRadius.circular(30.0),
        border: border ?? Border.all(color: Color(0xFF70C5E5), width: 1.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : BorderRadius.circular(30.0),
          onTap: onPressed,
          child: Center(
            child: Padding(
              padding: padding,
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}