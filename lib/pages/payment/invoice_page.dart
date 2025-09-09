import 'package:admin_ocean_learn2/widget/payment_component/invoice_component/invoice_header.dart';
import 'package:admin_ocean_learn2/widget/payment_component/invoice_component/invoice_illustration.dart';
import 'package:admin_ocean_learn2/widget/payment_component/invoice_component/payment_method_selector.dart';
import 'package:admin_ocean_learn2/widget/payment_component/invoice_component/subscription_detail.dart';
import 'package:admin_ocean_learn2/widget/payment_component/invoice_component/thank_button.dart';
import 'package:admin_ocean_learn2/widget/payment_component/invoice_component/transfer_proof.dart';
import 'package:flutter/material.dart';
import 'package:admin_ocean_learn2/model/subscription_model.dart';
import 'package:admin_ocean_learn2/pages/payment/payment_controller.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class InvoicePage extends StatefulWidget {
  final SubscriptionModel subscription;
  final PaymentController controller;

  const InvoicePage({
    Key? key,
    required this.subscription,
    required this.controller,
  }) : super(key: key);

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final ScreenshotController screenshotController = ScreenshotController();
  bool isDownloading = false;

  

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      // Try to get the Downloads directory
      Directory? downloadsDir;
      
      try {
        // For newer Android versions, use getExternalStorageDirectory
      final Directory downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }
      return downloadsDir;
    } catch (e) {
      print('Error accessing Downloads folder: $e');
      return null;
    }
  } else {
    return await getApplicationDocumentsDirectory();
  }
}

  Future<void> downloadInvoice() async {
    setState(() {
      isDownloading = true;
    });

    try {


      // Capture screenshot
      final Uint8List? imageBytes = await screenshotController.capture();
      
      if (imageBytes == null) {
        throw Exception('Failed to capture invoice screenshot');
      }

      // Get directory
      final Directory? directory = await _getDownloadDirectory();
      
      if (directory == null) {
        throw Exception('Could not access storage directory');
      }

      // Create filename with timestamp
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'invoice_${widget.subscription.month}_$timestamp.png';
      final String filePath = '${directory.path}/$fileName';

      // Save file
      final File file = File(filePath);
      await file.writeAsBytes(imageBytes);

      // Verify file was created
      if (await file.exists()) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invoice saved successfully!\nLocation: $filePath'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      } else {
        throw Exception('File was not created successfully');
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save invoice: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                downloadInvoice();
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralColor,
      appBar: AppBar(
        title: const Text(
          'Invoice Details',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: netralColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: pureBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: isDownloading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primaryColor,
                    ),
                  )
                : const Icon(Icons.download, color: primaryColor),
            onPressed: isDownloading ? null : downloadInvoice,
            tooltip: 'Download Invoice',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: pureWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    InvoiceHeader(subscription: widget.subscription),
                    const SizedBox(height: 32),
                    InvoiceIllustration(
                      paymentMethod: widget.subscription.detail.paymentMethod,
                    ),
                    SubscriptionDetails(
                      subscription: widget.subscription,
                      controller: widget.controller,
                    ),
                    PaymentMethodSelector(
                      paymentMethod: widget.subscription.detail.paymentMethod,
                    ),
                    TransferProofSection(
                      subscription: widget.subscription,
                      controller: widget.controller,
                    ),
                    ThankYouButton(
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}