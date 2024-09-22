import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:rive/rive.dart';
import 'package:solana/solana.dart';
import 'package:test/utils/rive_asset.dart';
import 'package:test/utils/rive_utils.dart';
import 'package:test/web3_services/alchemy_solana.dart';
import 'package:test/web3_services/infura_eth.dart';
import 'package:web3dart/web3dart.dart';
import 'package:convert/convert.dart'; // For converting values

class WalletHomePage extends StatefulWidget {
  List<String> mnemanicphrase;
  WalletHomePage({super.key, required this.mnemanicphrase});

  @override
  State<WalletHomePage> createState() => _WalletHomePageState();
}

class _WalletHomePageState extends State<WalletHomePage> {
  @override
  final String infuraUrl = "https://mainnet.infura.io/v3/0ee62698c82a4a82a9d1acbaef3f9c06";
  late Web3Client ethClient;
  String balanceETH = "0";
  String txHash = "";

  List<IconData> icons = [
    Icons.send,
    Icons.call_received_outlined,
    Icons.change_circle_outlined,
    Icons.shop,
  ];

  @override
  void initState() {
    super.initState();
    var httpClient = Client();
    ethClient = Web3Client(infuraUrl, httpClient);
  }

  //RIVE 
  List<RiveAsset> rive = [
    RiveAsset(artboard: "download", stateMachineName: "download_interactivity", title: "receive", src: "assets/rive_icons/web_icons_pack.riv"),
    RiveAsset(artboard: "download 2", stateMachineName: "download_interactivity", title: "send", src: "assets/rive_icons/web_icons_pack.riv"),
    RiveAsset(artboard: "refresh", stateMachineName: "refresh_interactivity", title: "transfert", src: "assets/rive_icons/web_icons_pack.riv"),
    RiveAsset(artboard: "www", stateMachineName: "www_interactivity", title: "p2p", src: "assets/rive_icons/web_icons_pack.riv"),
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: HexColor('#0E0E0E'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: height*0.05,right: width*0.13,left: width*0.13),
            height: height * 0.36,
            width: width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/icons/background_2.png',
                    ),
                    fit: BoxFit.cover)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.04),
                  child: Row(
                    children: [
                      Container(
                        height: height*0.07,
                        width: width*0.4,
                        decoration: BoxDecoration(
                          color: HexColor('#0E0E0E'),
                          borderRadius: BorderRadius.circular(height*0.03),
                        ),
                      )
                    ],
                  ),
                ),
                Text('Total Balance',style: TextStyle(color: Colors.white),),
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.04),
                  child: Text(
                    "0.0 USDT",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(4, (index) => GestureDetector(
                      onTap: () {
                        rive[index].input!.change(true);
                        Future.delayed(Duration(seconds: 3), () {
                          rive[index].input!.change(false);
                        });
                      },
                      child: Container(
                        height: height*0.06,
                        width: height*0.06,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        child: RiveAnimation.asset(
                          rive[index].src,
                          artboard: rive[index].artboard,
                          onInit: (artboard) {
                            StateMachineController controller = RiveUtils.getRiveController(artboard,stateMachineName: rive[index].stateMachineName);
                            rive[index].input = controller.findSMI("active") as SMIBool;
                          },
                        ),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: generateSolanaAddress,
            child: Text("Generate Solana"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: fetchBalance,
            child: Text("Show Balance"),
          ),
          SizedBox(height: 20),
          if (txHash.isNotEmpty) Text("Transaction Hash: $txHash"),
        ],
      ),
    );
  }

  void generateEthereumWallet() {
    var rng = Random.secure();
    var privateKey =
        EthPrivateKey.createRandom(rng); // Generates a random private key
    var address =
        privateKey.address; // Derives the wallet address from the private key

    print('Your private key: ${hex.encode(privateKey.privateKey)}');
    print('Your Ethereum address: ${address.hex}');

    // privatekey : 00b15e1f407a78611179c110fc867ebe2dd0e8a9ebf8339ea4993f52d05141c309
    // address : 0xae3a5014930650be7190e4032149b9550e7254be
    // hech : 0xc1db60e353f9ad2ef8da87a6195c7b924f9c5c4cc4984b48f8b0d15b20028fe7

    // recipient privatekey : 00e3b3165b0bc404e32f3fd9b4399262d80dfb52d7955b1e6eebed7575a026a64e
    // recipient adress : 0xab9ab2db0d1f38d921c410f3e2cbacb213cca470

    //infura api key : 0ee62698c82a4a82a9d1acbaef3f9c06
    //infura HTTPS : https://mainnet.infura.io/v3/0ee62698c82a4a82a9d1acbaef3f9c06
  }

  Future<void> getBalance() async {
    // Replace with the Ethereum address you're testing
    var address =
        EthereumAddress.fromHex("0xae3a5014930650be7190e4032149b9550e7254be");

    // Get the balance in Wei (smallest unit of ETH)
    EtherAmount ethBalance = await ethClient.getBalance(address);

    // Update the UI
    setState(() {
      balanceETH = ethBalance.getValueInUnit(EtherUnit.ether).toString();
    });
  }

  Future<void> sendEth() async {
    var ethereumService = EthereumService();

    String privateKey =
        "00b15e1f407a78611179c110fc867ebe2dd0e8a9ebf8339ea4993f52d05141c309";
    String recipientAddress =
        "0xab9ab2db0d1f38d921c410f3e2cbacb213cca470"; // Another testnet address
    double amountInEth = 0.01; // Amount you want to send

    String txHash = await ethereumService.sendTransaction(
        privateKey, recipientAddress, amountInEth);

    setState(() {
      this.txHash = txHash;
    });
  }


  void generateSolanaAddress() async {
    // Generate a new keypair (both public and private keys)
    final Ed25519HDKeyPair keyPair = await Ed25519HDKeyPair.random();
  
    // Get the public key (Solana address)
    final String publicKey = keyPair.address;
  
    // Get the private key (for signing transactions)
    final privateKey = keyPair.publicKey;
  
    print('Public Key: $publicKey');
    print('Private Key: $privateKey');
  }

  void fetchBalance() {
    // Initialize the Solana service with your Alchemy Solana RPC URL
    final solanaService = SolanaService("https://solana-mainnet.g.alchemy.com/v2/blDa7IybuNsPEL8Uv-TdcjXWmwCATVRZ");

    // Replace with your Solana public key
    final String publicKey = "Hvn5Cd2rZsDTGcg8syhyqqXg6NPFy17BPDvvX4WspGEk";

    // Fetch the balance of the account
    solanaService.getBalance(publicKey);
  }
}
