import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';

class InvoiceIllustration extends StatelessWidget {
  final String paymentMethod;

  const InvoiceIllustration({
    super.key,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Center(
        child: SvgPicture.asset(
          'assets/svg/invoice.svg',
          height: 150,
          width: 150,
          placeholderBuilder: (context) => Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              paymentMethod.toLowerCase() == 'cash' 
                ? Icons.money 
                : Icons.account_balance,
              size: 60,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}