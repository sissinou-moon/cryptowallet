import 'package:cherry_toast/cherry_toast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:test/coingecko/coingecko_services.dart';
import 'package:test/local_storage/hive_services.dart';
import 'package:test/web3_services/alchemy_eth.dart';
import 'package:test/web3_services/ton_services.dart';
import 'package:tonutils/tonutils.dart';

class SendTokensPage extends StatefulWidget {
  const SendTokensPage({super.key});

  @override
  State<SendTokensPage> createState() => _SendTokensPageState();
}

class _SendTokensPageState extends State<SendTokensPage> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  String selectedCoin = 'ton';
  String ethImage = 'https://cdn.pixabay.com/photo/2021/05/24/09/15/ethereum-logo-6278329_640.png';
  String tonImage = 'https://cryptocurrencyjobs.co/startups/assets/logos/ton-foundation.png';
  String usdtImage = 'https://seeklogo.com/images/T/tether-usdt-logo-FA55C7F397-seeklogo.com.png';
  String usdcImage = 'https://cryptologos.cc/logos/usd-coin-usdc-logo.png';

  double fee = 0.002;

  bool valideAmount = false;

  List<String> coins = [
    'ton',
    'usdt',
    'usdc',
  ];

  String selectedNetwork = 'the-open-network';

  List<String> networks = [
    'the-open-network',
  ];


  HiveServices hiveServices = HiveServices();
  CoinGeckoServices coinGeckoServices = CoinGeckoServices();
  AlchemyEth alchemyEth = AlchemyEth();
  TonServices tonServices = TonServices();

  
  @override
  void initState() {
    super.initState();

    amountController.text = '0.0';

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
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: width*0.07,left: width*0.07),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: height*0.03),
                  child: Text('Withdrawal Token', style: TextStyle(color: Colors.white,fontSize: height*0.015,fontWeight: FontWeight.w600),),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.03,top: height*0.01),
                  child: Container(
                    padding: EdgeInsets.only(right: width*0.05,bottom: height*0.01),
                    alignment: Alignment.center,
                    height: height*0.075,
                    width: width,
                    decoration: BoxDecoration(
                      color: HexColor('1E201E'),
                      borderRadius: BorderRadius.circular(height*0.023)
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              items: coins.map((String coin) => DropdownMenuItem<String>(
                                value: coin,
                                child: Padding(
                                  padding: EdgeInsets.only(top: height*0.01),
                                  child: Row(
                                    children: [
                                      SizedBox(height: height*0.05,width: height*0.05,child: ClipRRect(borderRadius: BorderRadius.circular(height*0.02),child: Image.network(coin == 'ethereum' ? ethImage : coin == 'ton' ? tonImage : coin == 'usdc' ? usdcImage : usdtImage,fit: BoxFit.cover,))),
                                      SizedBox(width: width*0.03,),
                                      Text(coin.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: height*0.017,fontWeight: FontWeight.w700),),
                                    ],
                                  ),
                                )
                              )).toList(),
                              value: selectedCoin,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedCoin = value!;
                                });
            
                                if (selectedCoin == 'ton' && selectedNetwork == 'ethereum') {
                                  setState(() {
                                    selectedNetwork = 'the-open-network';
                                  });
                                } else if(selectedCoin == 'ethereum' && selectedNetwork == 'the-open-network'){
                                  setState(() {
                                    selectedNetwork = 'ethereum';
                                  });
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
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height*0.03),
                  child: Text('Withdrawal Network', style: TextStyle(color: Colors.white,fontSize: height*0.015,fontWeight: FontWeight.w600),),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height*0.01,bottom: height*0.02),
                  child: Container(
                    padding: EdgeInsets.only(right: width*0.05,bottom: height*0.01),
                    alignment: Alignment.center,
                    height: height*0.075,
                    width: width,
                    decoration: BoxDecoration(
                      color: HexColor('1E201E'),
                      borderRadius: BorderRadius.circular(height*0.023)
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              items: networks.map((String network) => DropdownMenuItem<String>(
                                value: network,
                                child: Padding(
                                  padding: EdgeInsets.only(top: height*0.01),
                                  child: Row(
                                    children: [
                                      SizedBox(height: height*0.05,width: height*0.05,child: ClipRRect(borderRadius: BorderRadius.circular(height*0.02),child: Image.network(network == 'ethereum' ? ethImage : tonImage,fit: BoxFit.cover,))),
                                      SizedBox(width: width*0.03,),
                                      Text(network.toUpperCase() == 'THE-OPEN-NETWORK' ? 'TON(TONCOIN)' : network.toUpperCase() == 'ETHEREUM' ? 'ERC20' : network.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: height*0.017,fontWeight: FontWeight.w700),),
                                    ],
                                  ),
                                )
                              )).toList(),
                              value: selectedNetwork,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedNetwork = value!;
                                });
            
                                if (value == 'the-open-network' && selectedCoin == 'ethereum') {
                                  setState(() {
                                    selectedCoin = 'ton';
                                  });
                                } else if(value == 'ethereum' && selectedCoin == 'ton'){
                                  setState(() {
                                    selectedCoin = 'ethereum';
                                  });
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
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height*0.03),
                  child: Text('Withdrawal Address', style: TextStyle(color: Colors.white,fontSize: height*0.015,fontWeight: FontWeight.w600),),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height*0.01, bottom: height*0.02),
                  child: TextFormField(
                    controller: addressController,
                    validator: (value) {
                      if(value == null || value.isEmpty || value.length < 20) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: HexColor('1E201E'),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(height*0.023),
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height*0.03),
                  child: Text('Amount', style: TextStyle(color: Colors.white,fontSize: height*0.015,fontWeight: FontWeight.w600),),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height*0.01, bottom: height*0.02),
                  child: TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if(value == null || value.isEmpty || double.parse(value) < 0.002) {
                        return 'Please provide the amount that you want to send';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: HexColor('1E201E'),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(height*0.023),
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: height*0.17,
        width: width,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: Colors.white,width: 0.5))
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: height*0.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('You will receive', style: TextStyle(color: Colors.white,fontSize: height*0.015,fontWeight: FontWeight.bold),),
                  Text('${ (amountController.text.isNotEmpty && amountController.text != null && amountController.text != '') ? (double.parse(amountController.text) - fee) < 0 ? 0 : (double.parse(amountController.text) - fee).toStringAsFixed(5) : 0} $selectedCoin', style: TextStyle(color: Colors.white,fontSize: height*0.02,fontWeight: FontWeight.bold),),
                  Text('Fee of tranaction = $fee', style: TextStyle(color: Colors.white,fontSize: height*0.011,fontWeight: FontWeight.w300),),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                if(_formKey.currentState!.validate()) {
                  if (double.parse(amountController.text) > hiveServices.wallet['tokens']['the-open-network']['balance']) {
                    CherryToast.info(
                      title: Text('Insifficient balance!'),
                    ).show(context);
                  } else {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Scaffold(
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
                        backgroundColor: Colors.black,
                      ),
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: height*0.015),
                              child: SizedBox(
                                height: height*0.13,
                                width: height*0.13,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(height),
                                  child: Image.network(tonImage)
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: height*0.07),
                              child: Text('Confirm the action',style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: height*0.019,fontWeight: FontWeight.w500),),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: height*0.1),
                              child: Container(
                                padding: EdgeInsets.only(right: width*0.07,left: width*0.07),
                                alignment: Alignment.center,
                                height: height*0.43,
                                width: width*0.86,
                                decoration: BoxDecoration(
                                  color: HexColor('1E201E'),
                                  borderRadius: BorderRadius.circular(height*0.023),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: height*0.03),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Receiver : ',style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: height*0.019,fontWeight: FontWeight.w500),),
                                          Expanded(child: SizedBox(width: 1,)),
                                          SizedBox(
                                            width: width*0.15,
                                            child: Text(addressController.text,style: TextStyle(color: Colors.white,fontSize: height*0.019,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)
                                          ),
                                          Text('${addressController.text[addressController.text.length-5]}${addressController.text[addressController.text.length-4]}${addressController.text[addressController.text.length-3]}${addressController.text[addressController.text.length-2]}${addressController.text[addressController.text.length-1]}',style: TextStyle(color: Colors.white,fontSize: height*0.019,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: height*0.03),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Network : ',style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: height*0.019,fontWeight: FontWeight.w500),),
                                          Expanded(child: SizedBox(width: 1,)),
                                          Text(selectedNetwork.toUpperCase() == 'THE-OPEN-NETWORK' ? 'TON(TONCOIN)' : selectedNetwork,style: TextStyle(color: Colors.white,fontSize: height*0.019,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: height*0.03),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Token : ',style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: height*0.019,fontWeight: FontWeight.w500),),
                                          Expanded(child: SizedBox(width: 1,)),
                                          Text(selectedCoin.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: height*0.019,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: height*0.03),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Amount : ',style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: height*0.019,fontWeight: FontWeight.w500),),
                                          Expanded(child: SizedBox(width: 1,)),
                                          Text(amountController.text,style: TextStyle(color: Colors.white,fontSize: height*0.019,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: height*0.03),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Fees : ',style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: height*0.019,fontWeight: FontWeight.w500),),
                                          Expanded(child: SizedBox(width: 1,)),
                                          Text(selectedNetwork.toUpperCase() == 'THE-OPEN-NETWORK' ? '0.05 TON' : '0.001 ETH',style: TextStyle(color: Colors.white,fontSize: height*0.019,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    if(selectedNetwork.toUpperCase() == 'THE-OPEN-NETWORK') Padding(
                                      padding: EdgeInsets.only(bottom: height*0.03),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Message : ',style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: height*0.019,fontWeight: FontWeight.w500),),
                                          Expanded(child: SizedBox(width: 1,)),
                                          Text('From versili app',style: TextStyle(color: Colors.white,fontSize: height*0.019,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: height*0.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Date : ',style: TextStyle(color: Colors.white.withOpacity(0.5),fontSize: height*0.019,fontWeight: FontWeight.w500),),
                                          Expanded(child: SizedBox(width: 1,)),
                                          Text(DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),style: TextStyle(color: Colors.white,fontSize: height*0.019,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: width*0.07,left: width*0.07),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: height * 0.1,
                                      child: SlideAction(
                                        height: height*0.07,
                                        sliderButtonIconSize: height*0.02,
                                        sliderButtonIconPadding: height*0.023,
                                        sliderRotate: false,
                                        borderRadius: height*0.023,
                                        text: 'Slide to confirm the action',
                                        textStyle: TextStyle(
                                          fontSize: height*0.013,
                                          color: Colors.white.withOpacity(0.8)
                                        ),
                                        innerColor: HexColor('41C9E2'),
                                        outerColor: HexColor('6F6F6F').withOpacity(0.44),
                                        sliderButtonIcon: Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,size: height*0.015,),
                                        onSubmit: () {
                                          return Future.delayed(const Duration(milliseconds: 20), () {
                                            sendTonTransaction();
                                            Navigator.of(context).pop();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )));
                  }
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: height*0.065,
                width: width*0.4,
                decoration: BoxDecoration(
                  color: addressController.text.length < 10 ? Colors.white.withOpacity(0.3) : amountController.text.isNotEmpty ? double.parse(amountController.text) < 0.003 ? Colors.white.withOpacity(0.3) : Colors.white : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(height*0.023),
                ),
                child: Text('Withdraw', style: TextStyle(color: Colors.black,fontSize: height*0.017,fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendTonTransaction() async {

    tonServices.sendTonTransaction(
      hiveServices.wallet['tokens']['the-open-network']['publicKey'], 
      hiveServices.wallet['tokens']['the-open-network']['privateKey'], 
      addressController.text, 
      amountController.text
    );
  }
}