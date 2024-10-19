import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bip32/bip32.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rive/rive.dart' as rive;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solana/base58.dart';
import 'package:solana/solana.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test/local_storage/hive_services.dart';
import 'package:test/main_pages/Home.dart';
import 'package:test/main_pages/Source.dart';
import 'package:test/utils/rive_asset.dart';
import 'package:test/utils/rive_utils.dart';
import 'package:test/web3_services/alchemy_solana.dart';
import 'package:test/web3_services/encrypting.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:tonutils/tonutils.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:convert/convert.dart'; // For converting values
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:bip39/bip39.dart' as bip39;

class WalletProtectionPage extends StatefulWidget {
  List<String> mnemanicphrase;
  WalletProtectionPage({super.key, required this.mnemanicphrase});

  @override
  State<WalletProtectionPage> createState() => _WalletProtectionPageState();
}

class _WalletProtectionPageState extends State<WalletProtectionPage> {

  
  final LocalAuthentication _auth = LocalAuthentication();

  //
  bool _isAuthenticated = false;

  //
  RiveAsset tada = RiveAsset(artboard: "Tada", stateMachineName: "controller", title: "tada", src: "assets/rive_icons/emoji.riv");
  HiveServices hiveServices = HiveServices();

  //
  @override
  void initState() {
    super.initState();

    if (hiveServices.bx.get('wallet') == null) {
      hiveServices.Init();
    } else {
      hiveServices.Load();
    }
  }

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
                  TipDialogHelper.loading("Please wait , it takes over 2 minut...");
                  Future.delayed(Duration(milliseconds: 300), () {
                    CreateWallet(widget.mnemanicphrase.join(' '), height, width);
                  });
                },
                child: Text('Maybe later',style: TextStyle(color: HexColor('41C9E2'),fontSize: height*0.019,fontWeight: FontWeight.w600),)
              ),
            ),
            Align(
              alignment: Alignment(0, 0.9),
              child: GestureDetector(
                onTap: () {
                  _authenticate().whenComplete(() {
                    TipDialogHelper.loading("Please wait , it takes between 1 to 2 minut...");
                    Future.delayed(Duration(milliseconds: 300), () {
                      CreateWallet(widget.mnemanicphrase.join(' '), height, width);
                    });
                  }); // Prompt fingerprint authentication when app starts
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

    } catch (e) {
      print(e);
    }
  }

  Future<Map> generateEthereumWallet() async {
    // Generate seed from mnemonic
    final seed = bip39.mnemonicToSeed(widget.mnemanicphrase.join(' '));

    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privateKey = hex.encode(master.key);

    // Convert to Ethereum address
    final eth = EthPrivateKey.fromHex(privateKey);
    final address = eth.address;

    return {'privateKey': privateKey, 'address': address.hex};
  }

  Future<Map> generateTonWallet() async {
    final netClient = TonJsonRpc();
    //final client = TonJsonRpc('https://toncenter.com/api/v2/jsonRPC');

    final keyPair = Mnemonic.toKeyPair(widget.mnemanicphrase);
    
    final wallet = WalletContractV4R2.create(publicKey: keyPair.publicKey);
//
    //final openedContract = client.open(wallet);
    //final balance = await openedContract.getBalance();

    return {'privateKey': keyPair.privateKey, 'address': wallet.address.toString(), 'publicKey': keyPair.publicKey};
  }

  Future<Map> generateSolanaAddress() async {
    final Ed25519HDKeyPair pair;
    pair = await Ed25519HDKeyPair.fromMnemonic(widget.mnemanicphrase.join(' '));
    final privateKey = await pair.extract().then((value) => value.bytes).then(base58encode);
    final publicKey = pair.address;

    return {'privateKey': privateKey, 'address': publicKey};
  }

  String generateEncryptingKey() {
    final random = Random.secure();
    final List<int> values = List<int>.generate(32, (i) => random.nextInt(256));
    String encryptionKey = base64Url.encode(values);   
    return encryptionKey;
  }

  Map encryptingData(String data, String key) {
    Map encryptedData = EncryptingData.encryptData(data, key);
    return encryptedData;
  }

  String generateId(int length) {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();

    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void CreateWallet(String mnemonicPhrase, double height, double width) async {
    hiveServices.delete();
    String key = generateEncryptingKey();
    String id = generateId(9);

    String Eth = (await generateEthereumWallet())['address'];
    Map Ton = await generateTonWallet();

    Map cryptedMnemonicPhrase = encryptingData(mnemonicPhrase, key);
    Map eth_crypted = encryptingData(Eth, key);
    Map ton_crypted = encryptingData(Ton['address'], key);
    try {
      final response = await Supabase.instance.client
        .from('wallets')
        .insert({
          'id': id,
          'mnemonic': cryptedMnemonicPhrase['encryptedData'],
          'eth': eth_crypted['encryptedData'],
          'ton': ton_crypted['encryptedData'],
        });
      
      final store_crypting_details = await Supabase.instance.client
        .from('crypting_data')
        .insert({
          'id': id,
          'key': key,
          'mnemonic_iv': cryptedMnemonicPhrase['iv'],
          'eth_iv': eth_crypted['iv'],
          'ton_iv': ton_crypted['iv']
        });
    } catch (e) {
      print(e);
    }

    hiveServices.wallet.addAll({
      'mnemonic': widget.mnemanicphrase,
      'localAuth': _isAuthenticated,
      'tokens': {
        'ethereum': {
          'address': Eth,
          'privateKey': (await generateEthereumWallet())['privateKey'],
          'balance': 0.0
        },
        'the-open-network': {
          'address': Ton['address'],
          'privateKey': Ton['privateKey'],
          'publicKey': Ton['publicKey'],
          'balance': 0.0
        },
        'tether': {
          'balance': 0.0,
          'fromTon': 0.0,
          'fromEth': 0.0
        },
        'usd-coin': {
          'balance': 0.0,
          'fromTon': 0.0,
          'fromEth': 0.0
        }
      },
    });
    hiveServices.Upload();

    Future.delayed(Duration(seconds: 1), () => TipDialogHelper.dismiss);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SourcePage(),));
    showModalBottomSheet(
      context: context, 
      backgroundColor: const Color.fromARGB(255, 19, 19, 19),
      builder: (context) => Container(
        height: height*0.43,
        width: width,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 19, 19, 19),
            borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50)),
          ),
          child: Padding(
            padding: EdgeInsets.only(right: width*0.05,left: width*0.05),
            child: Column(
              children: [
                SizedBox(
                  height: height*0.23,
                  child: rive.RiveAnimation.asset(
                    tada.src,
                    artboard: tada.artboard,
                    onInit: (artboard) {
                      rive.StateMachineController controller = RiveUtils.getRiveController(artboard, stateMachineName: tada.stateMachineName);
                      tada.input = controller.findSMI("isHover") as rive.SMIBool;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Text('Wallet successfully created!',style: TextStyle(fontSize: height*0.021,fontWeight: FontWeight.bold,color: Colors.white),),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.05),
                  child: Text('Explore 100+ coins now.',style: TextStyle(fontSize: height*0.013,fontWeight: FontWeight.w100,color: Colors.white),),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: height*0.065,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(height*0.023),
                      ),
                      child: Text('Got it!',style: TextStyle(fontSize: height*0.017,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
