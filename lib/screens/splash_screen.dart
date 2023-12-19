import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner/screens/home_screen.dart';

import 'package:qr_scanner/utils/colors.dart';
import 'package:qr_scanner/widgets/text_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 0), () async {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, //code para mawala to ang debug nga pula sa top right sa app screen
      home: Scaffold(
        backgroundColor: Colors.red[50],
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitFadingFour(
              color: primary,
              size: 280.0,
            ),
            const SizedBox(
              height: 50,
            ),
            TextRegular(text: 'Loading...', fontSize: 12, color: primary!)
          ],
        )),
      ),
    );
  }
}
