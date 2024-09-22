import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:rive/rive.dart';
import 'package:test/get_started_pages/WalletProtection.dart';
import 'package:test/utils/rive_asset.dart';
import 'package:test/utils/rive_utils.dart';

class CreateMnemonicPage extends StatefulWidget {
  const CreateMnemonicPage({super.key});

  @override
  State<CreateMnemonicPage> createState() => _CreateMnemonicPageState();
}

class _CreateMnemonicPageState extends State<CreateMnemonicPage> {
  //
  List<String> mnemonicPhrase = [];

  //
  bool alreadyHasPhrase = false;
  bool showMnemonicPhrase = false;
  bool _continue = false;

  //
  RiveAsset riveEye = RiveAsset(
      artboard: "Eyetrack",
      stateMachineName: "State Machine 1",
      title: "eye",
      src: "assets/rive_icons/eye_track_test.riv");

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
        title: Text(
          'Mnimonic wallet',
          style: TextStyle(
              color: Colors.white,
              fontSize: height * 0.025,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: HexColor('0E0E0E'),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            right: width * 0.05, left: width * 0.05, bottom: height * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: height * 0.3,
                width: width,
                child: SvgPicture.asset('assets/svg/Wallet-bro.svg')),
            Padding(
              padding: EdgeInsets.only(top: height * 0.02),
              child: GestureDetector(
                onTap: () {
                  if (!alreadyHasPhrase) generateMnemonicPhrase();
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 700),
                  alignment: Alignment.center,
                  height: height * 0.065,
                  width: width,
                  decoration: BoxDecoration(
                      color: alreadyHasPhrase
                          ? Colors.white.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(height * 0.023)),
                  child: Text(
                    'Generate my mnemonic phrase',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: height * 0.017,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.02),
              child: SizedBox(
                height: height * 0.3,
                width: width,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: height * 0.0,
                      mainAxisExtent: height * 0.05,
                    ),
                    itemCount: mnemonicPhrase.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '${index + 1}',
                            style: TextStyle(color: Colors.white),
                          ),
                          !showMnemonicPhrase ? Container(
                            height: height * 0.03,
                            width: width * 0.2,
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                  sigmaX: 3,
                                  sigmaY: 3,
                                  tileMode: TileMode.decal),
                              child: Text(mnemonicPhrase[index],
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ) : Container(
                            height: height * 0.03,
                            width: width * 0.2,
                            child: Text(mnemonicPhrase[index],
                                  style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      );
                    }),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.02),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if(_continue) Navigator.push(context, MaterialPageRoute(builder: (context) => WalletProtectionPage(mnemanicphrase: mnemonicPhrase,)));
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        alignment: Alignment.center,
                        height: alreadyHasPhrase ? height * 0.065 : 0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(height * 0.023),
                          color: _continue ? Colors.white : Colors.white.withOpacity(0.1),
                        ),
                        child: Text('Continue',style: TextStyle(color: Colors.black,fontSize: height*0.019,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.02),
                    child: GestureDetector(
                      onTap: () {
                        if (riveEye.input!.value) {
                          riveEye.input!.change(false);
                        } else {
                          riveEye.input!.change(true);
                        }
                        setState(() {
                          showMnemonicPhrase = !showMnemonicPhrase;
                          _continue = true;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: alreadyHasPhrase ? height * 0.065 : 0,
                        width: height * 0.065,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(height * 0.023),
                          color: Colors.white,
                        ),
                        child: RiveAnimation.asset(
                          riveEye.src,
                          artboard: riveEye.artboard,
                          onInit: (artboard) {
                            StateMachineController controller = RiveUtils.getRiveController(artboard,stateMachineName: riveEye.stateMachineName);
                            riveEye.input = controller.findSMI("isTab") as SMIBool;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void generateMnemonicPhrase() {
    String mnemonic = bip39.generateMnemonic();
    print(mnemonic.split(' '));
    setState(() {
      mnemonicPhrase = mnemonic.split(' ');
      alreadyHasPhrase = true;
    });
  }
}
