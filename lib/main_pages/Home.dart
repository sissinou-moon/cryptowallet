import 'dart:convert';
import 'dart:math';
import 'package:bip32/bip32.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart' as rv;
import 'package:solana/solana.dart';
import 'package:test/coingecko/coingecko_services.dart';
import 'package:test/local_storage/hive_services.dart';
import 'package:test/main_pages/Exchange.dart';
import 'package:test/main_pages/Receive.dart';
import 'package:test/main_pages/Send.dart';
import 'package:test/main_pages/ThisCrypto.dart';
import 'package:test/utils/rive_asset.dart';
import 'package:test/utils/rive_utils.dart';
import 'package:test/web3_services/alchemy_eth.dart';
import 'package:test/web3_services/alchemy_solana.dart';
import 'package:test/web3_services/infura_eth.dart';
import 'package:test/web3_services/ton_services.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:convert/convert.dart'; // For converting values
import 'package:bip39/bip39.dart' as bip39;

class WalletHomePage extends StatefulWidget {
  WalletHomePage({super.key});

  @override
  State<WalletHomePage> createState() => _WalletHomePageState();
}

class _WalletHomePageState extends State<WalletHomePage> {
  String userCoins = ',';
  String usuallyCoins = 'the-open-network,tether,usd-coin';
  
  double solanaBalance = 0.0;
  double tonBalance = 0.0;
  double ethBalance = 2.0;

  List<IconData> icons = [
    Icons.send,
    Icons.call_received_outlined,
    Icons.change_circle_outlined,
    Icons.shop,
  ];
  ValueNotifier<List> tokensDetails = ValueNotifier<List>([]);
  ValueNotifier<double> total = ValueNotifier<double>(0.0);


  HiveServices hiveServices = HiveServices();
  CoinGeckoServices coinGeckoServices = CoinGeckoServices();
  AlchemyEth alchemyEth = AlchemyEth();
  TonServices tonServices = TonServices();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 200), () async {
      //alchemyEth.getERC20Tokens(hiveServices.wallet['eth_address']);
      //EthTokens();
      double tonB = await tonServices.getBalance(hiveServices.wallet['tokens']['the-open-network']['publicKey']);
      setState(() {
        hiveServices.wallet['tokens']['the-open-network']['balance'] = tonB;
        hiveServices.Upload();
      });
      CalculateTotalWithSortingCoins();
    });

    if (hiveServices.bx.get('wallet') == null) {
      hiveServices.Init();
    } else {
      hiveServices.Load();
    }
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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: height*0.05,right: width*0.07,left: width*0.07),
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
                          child: ValueListenableBuilder<double>(
                            valueListenable: total,
                            builder: (context, value, child) {
                              return Text(
                                '${value.toStringAsFixed(5)}\$',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ...List.generate(4, (index) => GestureDetector(
                              onTap: () {
                                //setState(() {
                                //  hiveServices.wallet['tokens']['solana']['balance'] = 3.378;
                                //  hiveServices.Upload();
                                //});
                                //hiveServices.delete();
                                print(hiveServices.wallet['tokens']['the-open-network']['balance']);
                                rive[index].input!.change(true);
                                Future.delayed(Duration(milliseconds: 1000), () {
                                  if(index == 2) Navigator.push(context, MaterialPageRoute(builder: (context) => ExchangePage()));
                                  if(index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => ReceivePage()));
                                  if(index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => SendTokensPage()));
                                  rive[index].input!.change(false);
                                });
                              },
                              child: Container(
                                height: height*0.065,
                                width: height*0.065,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                child: rv.RiveAnimation.asset(
                                  rive[index].src,
                                  artboard: rive[index].artboard,
                                  onInit: (artboard) {
                                    rv.StateMachineController controller = RiveUtils.getRiveController(artboard,stateMachineName: rive[index].stateMachineName);
                                    rive[index].input = controller.findSMI("active") as rv.SMIBool;
                                  },
                                ),
                              ),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: width*0.07,left: width*0.07,top: height*0.03),
                    child: Text('Assets',style: TextStyle(color: Colors.white,fontSize: height*0.027,fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: SizedBox(
                      height: height*0.53,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: _fetchForBuildingWidget(), 
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              height: height*0.4,
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.black
                              ),
                              child: ListView.builder(
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: width*0.07,left: width*0.07,bottom: height*0.02),
                                    child: Container(
                                      padding: EdgeInsets.only(right: width*0.03,left: width*0.03),
                                      height: height*0.07,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: HexColor('1E201E'),
                                        borderRadius: BorderRadius.circular(height*0.023),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: width*0.02,left: width*0.02),
                                            child: Container(
                                              height: height*0.05,
                                              width: height*0.05,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey.withOpacity(0.5)
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(bottom: height*0.01,top: height*0.01),
                                                child: Container(
                                                  height: height*0.02,
                                                  width: width*0.2,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    borderRadius: BorderRadius.circular(height*0.007),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(bottom: 0),
                                                child: Container(
                                                  height: height*0.02,
                                                  width: width*0.4,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    borderRadius: BorderRadius.circular(height*0.007),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              width: 1,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(bottom: height*0.01,top: height*0.01),
                                                child: Container(
                                                  height: height*0.02,
                                                  width: width*0.13,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    borderRadius: BorderRadius.circular(height*0.007),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(bottom: 0),
                                                child: Container(
                                                  height: height*0.02,
                                                  width: width*0.13,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    borderRadius: BorderRadius.circular(height*0.007),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              ),
                            );
                          } else if(snapshot.hasError){
                            return Center(child: Text('Error: ${snapshot.error}',style: TextStyle(color: Colors.red),),);
                          } else if(snapshot.hasData) {
                            return ListView.builder(
                              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                              itemCount:  snapshot.data!.length,
                              itemBuilder: (context,index) {
                                final coinData = snapshot.data![index];
                                String balancePrice = (hiveServices.wallet['tokens'][coinData['id']]['balance'] * coinData['current_price']).toStringAsFixed(5);
                                String balance = hiveServices.wallet['tokens'][coinData['id']]['balance'].toStringAsFixed(5);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => TokenPage(tokenDetails: coinData)));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(top: index != 0 ? height*0.01 : 0,right: width*0.07,left: width*0.07, bottom: index != (snapshot.data!.length - 1) ? 0 : height*0.09),
                                    child: Container(
                                      padding: EdgeInsets.only(left: width*0.015,right: 0.015),
                                      height: height*0.07,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: HexColor('1E201E'),
                                        borderRadius: BorderRadius.circular(height*0.023),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(height*0.023),
                                              color: coinData['id'] == 'ethereum' ? Colors.white  : Colors.transparent,
                                            ),
                                            child: ClipRRect(borderRadius: BorderRadius.circular(height*0.02),child: Image.network(coinData['image'],height: height*0.055,width: height*0.055,))
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: width*0.03),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(coinData['name'],style: TextStyle(color: Colors.white,fontSize: height*0.019,fontWeight: FontWeight.bold),),
                                                  Text('$balance ~ $balancePrice\$',style: TextStyle(color: Colors.white.withOpacity(0.7),fontSize: height*0.015,fontWeight: FontWeight.w300),),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: width*0.03),
                                            child: SizedBox(
                                              width: width*0.17,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(width: width*0.14,height: height*0.02,child: Text(coinData['current_price'].toString(),style: TextStyle(color: Colors.white,fontSize: height*0.019,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),)),
                                                  Text('${double.parse(coinData['price_change_percentage_24h'].toString()).toStringAsFixed(4)}%',style: TextStyle(color: coinData['price_change_percentage_24h'] < 0 ? Colors.red : Colors.green,fontSize: height*0.015,fontWeight: FontWeight.w300),),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            );
                          } else {
                            return Center(child: Text('No data available',style: TextStyle(color: Colors.white),)); 
                          }
                        }
                      ),
                    ),
                  ),
                ],
              ),
          ),
            IgnorePointer(
              child: Align(
                alignment: Alignment(0, 1.5),
                child: Opacity(opacity: 0.7,child: Transform.scale(scale: 1,child: Image.asset('assets/icons/background_4.png'))),
              ),
            ),
        ],
      ),
    );
  }

  void SolanaBalance() async {
    // Initialize the Solana service with your Alchemy Solana RPC URL
    final solanaService = SolanaService("https://solana-mainnet.g.alchemy.com/v2/blDa7IybuNsPEL8Uv-TdcjXWmwCATVRZ");

    // Replace with your Solana public key
    final Ed25519HDKeyPair keyPair = await Ed25519HDKeyPair.fromMnemonic(hiveServices.wallet['mnemonic'].join(' '));

    // Fetch the balance of the account
    solanaService.getBalance(keyPair.address);
  }

  void EthBalance() async {
    double balance = await alchemyEth.getEthBalance(hiveServices.wallet['tokens']['ethereum']['address']);
    setState(() {
      ethBalance = balance;
    });
  }
  
  void EthTokens() async {
    final List ethTokens = await alchemyEth.getERC20Tokens(hiveServices.wallet['tokens']['ethereum']['address']);

    try {
      for (var token in ethTokens) {
        String contractAddress = token['contractAddress'];
        final String weiBalanceHex = token['tokenBalance'];  // Balance in Wei (Hex)

        final BigInt weiBalance = BigInt.parse(weiBalanceHex.substring(2), radix: 16);
        final double tokenBalance = weiBalance / BigInt.from(10).pow(18);  // Convert from Wei to ETH

        final finalTokens = await coinGeckoServices.GetByContract(token['contractAddress']);
        if (finalTokens['id'] != 'weth') {
          setState(() {
            userCoins = '$userCoins,${finalTokens['id']}';
          });
        }
      }
    } catch (e) {
      throw Exception('Faild at <$e>');
    }
  }

  void CalculateTotalWithSortingCoins() async {
    final tokens = hiveServices.wallet['tokens'] as Map;
    total.value = 0.0;
    for (var i = 0; i < tokensDetails.value.length; i++) {
      for (var key in tokens.keys) {
        if (key == tokensDetails.value[i]['id']) {
          total.value = total.value + (tokens[key]['balance'] * tokensDetails.value[i]['current_price']);
        }
      }
    }
  }

  Future<List<Map<String, dynamic>>> _fetchForBuildingWidget() async {
    final data = await coinGeckoServices.GetTokensDetails('$usuallyCoins$userCoins');
    tokensDetails.value = data;
    return data;
  }
}
