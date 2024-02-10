import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyB0HijyKZx-5rqr8Ryp4HKHtZsflpoX0_o",
          projectId: "amusement-2e6a5",
          storageBucket: "amusement-2e6a5.appspot.com",
          messagingSenderId: "928127195723",
          appId: "1:928127195723:web:06834331060942c8ec0bce"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}
