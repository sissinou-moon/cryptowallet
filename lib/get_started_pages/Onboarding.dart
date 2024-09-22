import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:test/get_started_pages/CreateMnemonic.dart';
import 'package:test/get_started_pages/GetStarted.dart';
import 'package:test/main_pages/Home.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
              height: height,
              width: width,
              child: Transform.scale(
                scaleX: 1,
                child: Image.asset(
                  'assets/icons/background_3.png',
                  fit: BoxFit.cover,
                ),
              )),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(),
          )),
          Align(
            alignment: Alignment(0,-0.3),
            child: SizedBox(
              height: height*0.3,
              child: Image.asset('assets/icons/logo_app.png')
            ),
          ),
          SizedBox(
              height: height,
              width: width,
              child: Transform.scale(
                scaleX: 1,
                child: Image.asset(
                  'assets/icons/Rectangle.png',
                  fit: BoxFit.cover,
                ),
              )),
          Align(
            alignment: Alignment(0, 1),
            child: SizedBox(
              width: width,
              child: Padding(
                padding:
                    EdgeInsets.only(right: width * 0.07, left: width * 0.07),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'First arabic wallet',
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: height * 0.015,
                          color: Colors.white.withOpacity(0.7),
                          letterSpacing: 2),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * 0.0),
                      child: Text(
                        'Create your',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: height * 0.05,
                            color: Colors.white,
                            letterSpacing: 2),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: height * 0.01),
                      child: Text(
                        'crypto wallet',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: height * 0.05,
                            color: Colors.white,
                            letterSpacing: 2),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.02, bottom: height * 0.02),
                      child: SizedBox(
                        height: height * 0.1,
                        width: width * 0.7,
                        child: SlideAction(
                          height: height*0.07,
                          sliderButtonIconSize: height*0.02,
                          sliderButtonIconPadding: height*0.023,
                          sliderRotate: false,
                          borderRadius: height*0.023,
                          text: 'Slide to create new wallet',
                          textStyle: TextStyle(
                            fontSize: height*0.013,
                            color: Colors.white.withOpacity(0.8)
                          ),
                          innerColor: HexColor('41C9E2'),
                          outerColor: HexColor('6F6F6F').withOpacity(0.44),
                          sliderButtonIcon: Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,size: height*0.015,),
                          onSubmit: () {
                            return Navigator.push(context, MaterialPageRoute(builder: (context) => CreateMnemonicPage()));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
