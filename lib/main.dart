import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test/firebase_options.dart';
import 'package:test/get_started_pages/GetStarted.dart';
import 'package:test/get_started_pages/Onboarding.dart';
import 'package:test/local_storage/hive_services.dart';
import 'package:test/main_pages/Home.dart';
import 'package:test/main_pages/Source.dart';
import 'package:test/web3_pages/CreateWallet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://nucoujmikcibqiouadpl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im51Y291am1pa2NpYnFpb3VhZHBsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjcwMDUyNjYsImV4cCI6MjA0MjU4MTI2Nn0.HwDmpVR4T0X-RQJN4_AfHib6E-u9PuPJ1TLNn2wpxwk',
  );
  await Hive.initFlutter();
  var box = await Hive.openBox('wallet');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  HiveServices hiveServices = HiveServices();
  late bool switch_indicator;

  @override
  void initState() {
    super.initState();

    if (hiveServices.bx.get('wallet') == null) {
      switch_indicator = false;
      hiveServices.Init();
    } else {
      switch_indicator = true;
      hiveServices.Load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Versili crypto',
      home: switch_indicator ? SourcePage() : OnBoardingPage(),
    );
  }
}

