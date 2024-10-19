import 'dart:convert';
import 'dart:typed_data';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:solana/solana.dart';
import 'package:test/coingecko/coingecko_services.dart';
import 'package:test/local_storage/hive_services.dart';
import 'package:test/web3_services/alchemy_eth.dart';
import 'package:test/web3_services/alchemy_solana.dart';
import 'package:test/web3_services/uniswapEth.dart';
import 'package:web3dart/web3dart.dart';

class ExchangePage extends StatefulWidget {
  ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {

  String selectedNetwork = 'the-open-network';
  String selectedUSDCoin = 'tether';
  String ethImage = 'https://cdn.pixabay.com/photo/2021/05/24/09/15/ethereum-logo-6278329_640.png';
  String tonImage = 'https://cryptocurrencyjobs.co/startups/assets/logos/ton-foundation.png';
  String usdtImage = 'https://seeklogo.com/images/T/tether-usdt-logo-FA55C7F397-seeklogo.com.png';
  String usdcImage = 'https://cryptologos.cc/logos/usd-coin-usdc-logo.png';

  TextEditingController amountController = TextEditingController();

  double selectedBalance = 0.0;
  double willReceive = 0.0;

  List<String> networks = [
    'the-open-network',
  ];
  List<String> usdCoins = [
    'tether',
    'usd-coin'
  ];

  HiveServices hiveServices = HiveServices();
  CoinGeckoServices coinGeckoServices = CoinGeckoServices();
  AlchemyEth alchemyEth = AlchemyEth();
  SolanaService solanaServices = SolanaService('https://solana-mainnet.g.alchemy.com/v2/blDa7IybuNsPEL8Uv-TdcjXWmwCATVRZ');

  @override
  void initState() {
    super.initState();

    if (hiveServices.bx.get('wallet') == null) {
      hiveServices.Init();
    } else {
      hiveServices.Load();
    }

    selectedBalance = hiveServices.wallet['tokens']['ethereum']['balance'];
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: height * 0.02,
              color: Colors.white,
            )),
        title: Text('Exchange', style: TextStyle(color: Colors.white,fontSize: height*0.02,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: height*0.05,right: width*0.07,left: width*0.07),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: height*0.01,right: width*0.07,left: width*0.03,bottom: height*0.03),
                height: height*0.25,
                width: width,
                decoration: BoxDecoration(
                  color: HexColor('1E201E'),
                  borderRadius: BorderRadius.circular(height*0.033),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: height*0.03),
                      child: Row(
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              items: networks.map((String network) => DropdownMenuItem<String>(
                                value: network,
                                child: Padding(
                                  padding: EdgeInsets.only(top: height*0.01),
                                  child: Row(
                                    children: [
                                      SizedBox(height: height*0.05,width: height*0.05,child: ClipRRect(borderRadius: BorderRadius.circular(height*0.02),child: Image.network(network == 'ethereum' ? ethImage : tonImage,fit: BoxFit.cover,))),
                                      SizedBox(width: width*0.03,),
                                      Text(network.toUpperCase() == 'THE-OPEN-NETWORK' ? 'TON' : network.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: height*0.017,fontWeight: FontWeight.w700),),
                                    ],
                                  ),
                                )
                              )).toList(),
                              value: selectedNetwork,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedNetwork = value!;
                                  amountController.clear();
                                });
                                for (var key in hiveServices.wallet['tokens'].keys) {
                                  if (value == key) {
                                    setState(() {
                                      selectedBalance = double.parse(hiveServices.wallet['tokens'][key]['balance'].toString());
                                    });
                                  }
                                }
                              },
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(height*0.023),
                                )
                              ),
                              iconStyleData: IconStyleData(
                                icon: Icon(Icons.arrow_downward_outlined,size: height*0.02,color: Colors.white,)
                              ),
                            ),
                          ),
                          Expanded(child: SizedBox(width: 1,)),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                amountController.text = '$selectedBalance';
                              });
                              double price = await getRealTimeData();
                              setState(() {
                                willReceive = price * double.parse(amountController.text);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: height*0.035,
                              width: width*0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(height*0.023),
                                color: Colors.transparent,
                                border: Border.all(color: Colors.white)
                              ),
                              child: Text('Max', style: TextStyle(color: Colors.white,fontSize: height*0.015),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: width*0.6,
                        child: TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white,fontSize: height*0.04,fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) async {
                            if (double.parse(value) > selectedBalance) {
                              setState(() {
                                amountController.text = '$selectedBalance';
                              });
                            } else if (double.parse(value) < 0) {
                              setState(() {
                                amountController.text = '0';
                              });
                            }
                            double price = await getRealTimeData();
                            setState(() {
                              willReceive = price * double.parse(amountController.text);
                            });
                          },
                        ),
                      )
                    ),
                    Text('Your $selectedNetwork balance: $selectedBalance',style: TextStyle(color: Colors.white,fontSize: height*0.01),)
                  ],
                ),
              ),
              SizedBox(height: height*0.015,),
              Container(
                padding: EdgeInsets.only(top: height*0.01,right: width*0.07,left: width*0.03,bottom: height*0.01),
                height: height*0.25,
                width: width,
                decoration: BoxDecoration(
                  color: HexColor('1E201E'),
                  borderRadius: BorderRadius.circular(height*0.033),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: height*0.03),
                      child: Row(
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              items: usdCoins.map((String usdcoin) => DropdownMenuItem<String>(
                                value: usdcoin,
                                child: Padding(
                                  padding: EdgeInsets.only(top: height*0.01),
                                  child: Row(
                                    children: [
                                      SizedBox(height: height*0.05,width: height*0.05,child: ClipRRect(borderRadius: BorderRadius.circular(height*0.02),child: Image.network(usdcoin == 'tether' ? usdtImage : usdcImage ,))),
                                      SizedBox(width: width*0.03,),
                                      Text(usdcoin.toUpperCase() == 'THETHER' ? 'USDT' : usdcoin.toUpperCase() == 'USD-COIN' ? 'USDC' : usdcoin.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: height*0.017,fontWeight: FontWeight.w700),),
                                    ],
                                  ),
                                )
                              )).toList(),
                              value: selectedUSDCoin,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedUSDCoin = value!;
                                });
                              },
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(height*0.023),
                                )
                              ),
                              iconStyleData: IconStyleData(
                                icon: Icon(Icons.arrow_downward_outlined,size: height*0.02,color: Colors.white,)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: width*0.6,
                        child: Text(willReceive.toStringAsFixed(6),style: TextStyle(color: Colors.white,fontSize: height*0.04,fontWeight: FontWeight.bold),)
                      )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height*0.015),
                child: GestureDetector(
                  onTap: () async {
                    String alchemyApiKey = "blDa7IybuNsPEL8Uv-TdcjXWmwCATVRZ";
                    String alchemyRpcUrl = "https://eth-mainnet.alchemyapi.io/v2/$alchemyApiKey";
                    
                    Web3Client client = Web3Client(alchemyRpcUrl, Client());

                    if (selectedNetwork == 'ethereum') {
                      // Parse the amount from the text field as a double, then convert to wei
                      final double ethAmount = double.parse(amountController.text); // Make sure this is a valid number
                      final BigInt weiAmount = BigInt.from(ethAmount * (1e18));

                      // Use EtherAmount.fromWei() to specify the wei value
                      final amount = EtherAmount.fromUnitAndValue(EtherUnit.wei, weiAmount);

                      try {
                        final txHash = await swapEthForTokens(
                          client: client, 
                          privateKey: hiveServices.wallet['tokens'][selectedNetwork]['privateKey'], 
                          amountInEth: amount, 
                          tokenAddress: selectedUSDCoin == 'usd-coin' ? '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48' : '0xdAC17F958D2ee523a2206206994597C13D831ec7',
                        );

                        print('Transaction hash: $txHash');
                      } catch (e) {
                        throw Exception(e);
                      }
                    } else if (selectedNetwork =='the-open-network') {

                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: height*0.065,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(height*0.023),
                    ),
                    child: Text('Swap',style: TextStyle(color: Colors.black,fontSize: height*0.019,fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<double> getRealTimeData() async {
    final data = await coinGeckoServices.GetTokensDetails(selectedNetwork);
    print(data[0]['current_price']);
    return data[0]['current_price'];
  }
}