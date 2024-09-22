import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:local_auth/local_auth.dart';
import 'package:solana/solana.dart';
import 'package:test/main_pages/Home.dart';
import 'package:test/web3_services/alchemy_solana.dart';
import 'package:web3dart/web3dart.dart';
import 'package:convert/convert.dart'; // For converting values

class WalletProtectionPage extends StatefulWidget {
  List<String> mnemanicphrase;
  WalletProtectionPage({super.key, required this.mnemanicphrase});

  @override
  State<WalletProtectionPage> createState() => _WalletProtectionPageState();
}

class _WalletProtectionPageState extends State<WalletProtectionPage> {

  
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: HexColor('0E0E0E'),
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: height * 0.019,
            )),
        backgroundColor: HexColor('0E0E0E'),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            right: width * 0.05, left: width * 0.05, bottom: height * 0.03),
        child: Stack(
          children: [
            Align(
                alignment: Alignment(0, 0),
                child: Transform.scale(
                    scale: 2,
                    child: Image.asset('assets/icons/mockup.png'))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Protect your wallet',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.035,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Text(
                    'Add an extra layer of security by requiring Fingerprint to send transactions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: height * 0.04),
                  child: SizedBox(
                      height: height * 0.3,
                      child:
                          SvgPicture.asset('assets/svg/Fingerprint-bro.svg')),
                ),
              ],
            ),
            Align(
              alignment: Alignment(0, 1),
              child: Transform.scale(scale: 1.2,child: Image.asset('assets/icons/background_4.png')),
            ),
            Align(
              alignment: Alignment(0, 0.71),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WalletHomePage(mnemanicphrase: widget.mnemanicphrase,)));
                },
                child: Text('Maybe later',style: TextStyle(color: HexColor('41C9E2'),fontSize: height*0.019,fontWeight: FontWeight.w600),)
              ),
            ),
            Align(
              alignment: Alignment(0, 0.9),
              child: GestureDetector(
                onTap: () {
                  _authenticate(); // Prompt fingerprint authentication when app starts
                },
                child: Container(
                  alignment: Alignment.center,
                  height: height*0.065,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(height*0.023),
                    color: Colors.white,
                  ),
                  child: Text('Enable',style: TextStyle(color: Colors.black,fontSize: height*0.019,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to authenticate with fingerprint
  Future<void> _authenticate() async {
    try {
      bool authenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );

      setState(() {
        _isAuthenticated = authenticated;
      });

      if (_isAuthenticated) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WalletHomePage(mnemanicphrase: widget.mnemanicphrase,)));
      }
    } catch (e) {
      print(e);
    }
  }

}
