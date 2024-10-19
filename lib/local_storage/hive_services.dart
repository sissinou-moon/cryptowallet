import 'package:hive_flutter/hive_flutter.dart';

class HiveServices {
  // Variable to store wallet information
  Map wallet = {};

  final bx = Hive.box('wallet');

  void Init() {
    wallet = {};
  }

  void Load() {
    wallet = bx.get('wallet');
  }

  void Upload() {
    bx.put('wallet', wallet);
  }

  void delete() {
    bx.delete('wallet');
  }
}
