import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_scanner/utils/colors.dart';
import 'package:qr_scanner/widgets/button_widget.dart';
import 'package:qr_scanner/widgets/text_widget.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  String qrCode = 'Unknown';

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
      });
      print(qrCode);
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: TextRegular(
          text: 'SCANNER',
          fontSize: 18,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 250,
            ),
            const SizedBox(
              height: 100,
            ),
            ButtonWidget(
              color: primary,
              radius: 1000,
              label: 'Scan',
              onPressed: () {
                // AwesomeDialog(
                //   context: context,
                //   animType: AnimType.scale,
                //   dialogType: DialogType.ERROR,
                //   body: Center(
                //     child: TextBold(
                //       text: 'QR Scanned unsuccesfully!',
                //       fontSize: 18,
                //       color: Colors.red,
                //     ),
                //   ),
                //   title: 'This is Ignored',
                //   desc: 'This is also Ignored',
                //   btnCancelOnPress: () {},
                // ).show();
                scanQRCode();
              },
            ),
          ],
        ),
      ),
    );
  }
}
