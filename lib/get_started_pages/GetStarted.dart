import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:test/main_pages/Home.dart';
import 'package:test/utils/rive_asset.dart';
import 'package:test/utils/rive_utils.dart';

class GetstartedPage extends StatefulWidget {
  const GetstartedPage({super.key});

  @override
  State<GetstartedPage> createState() => _GetstartedPageState();
}

class _GetstartedPageState extends State<GetstartedPage> {

  //INSTANCES
  RiveAssetTrigger getstartedAnimation = RiveAssetTrigger(artboard: 'Logo', stateMachineName: 'State Machine 1', title: 'getstarted', src: 'assets/rive_icons/map_loadingscreen.riv');

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          getstartedAnimation.input!.fire();
          Future.delayed(Duration(milliseconds: 2500), () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WalletHomePage(mnemanicphrase: [],)));
          });
        },
        child: SizedBox(
          height: height,
          width: width,
          child: Transform.scale(
            scale: 2,
            child: RiveAnimation.asset(
              fit: BoxFit.cover,
              getstartedAnimation.src,
              artboard: getstartedAnimation.artboard,
              onInit: (artboard) {
                StateMachineController controller = RiveUtils.getRiveController(artboard, stateMachineName: getstartedAnimation.stateMachineName);
                getstartedAnimation.input = controller.findInput<bool>('StartLaunching') as SMITrigger;
              },
            ),
          ),
        ),
      ),
    );
  }
}