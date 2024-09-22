import 'package:rive/rive.dart';

class RiveAsset {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAsset(
      {required this.artboard,
      required this.stateMachineName,
      required this.title,
      required this.src});

  set setInput(SMIBool status) {
    input = status;
  }
}

class RiveAssetTrigger {
  final String artboard, stateMachineName, title, src;
  late SMITrigger? input;

  RiveAssetTrigger(
      {required this.artboard,
      required this.stateMachineName,
      required this.title,
      required this.src});

  set setInput(SMITrigger status) {
    input = status;
  }
}

class RiveAssetInput {
  final String artboard, stateMachineName, title, src;
  late SMIInput<double>? input;

  RiveAssetInput(
      {required this.artboard,
      required this.stateMachineName,
      required this.title,
      required this.src});

  set setInput(SMIInput<double> status) {
    input = status;
  }
}