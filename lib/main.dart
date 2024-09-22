import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test/firebase_options.dart';
import 'package:test/get_started_pages/GetStarted.dart';
import 'package:test/get_started_pages/Onboarding.dart';
import 'package:test/main_pages/Home.dart';
import 'package:test/web3_pages/CreateWallet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: OnBoardingPage(),
    );
  }
}

