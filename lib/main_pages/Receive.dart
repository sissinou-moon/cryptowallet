import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:test/coingecko/coingecko_services.dart';
import 'package:test/local_storage/hive_services.dart';
import 'package:test/web3_services/alchemy_eth.dart';
import 'package:test/web3_services/ton_services.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {

  String selectedNetwork = 'the-open-network';
  String ethImage = 'https://cdn.pixabay.com/photo/2021/05/24/09/15/ethereum-logo-6278329_640.png';
  String tonImage = 'https://cryptocurrencyjobs.co/startups/assets/logos/ton-foundation.png';

  List<String> networks = [
    'the-open-network',
    'ethereum',
  ];

  HiveServices hiveServices = HiveServices();
  CoinGeckoServices coinGeckoServices = CoinGeckoServices();
  AlchemyEth alchemyEth = AlchemyEth();
  TonServices tonServices = TonServices();
  
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
        child: SizedBox(
          width: height*0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Padding(
              //  padding: EdgeInsets.only(bottom: height*0.03),
              //  child: SizedBox(
              //    width: height*0.33,
              //    child: DropdownButtonHideUnderline(
              //      child: DropdownButton2<String>(
              //        items: networks.map((String network) => DropdownMenuItem<String>(
              //          value: network,
              //          child: Padding(
              //            padding: EdgeInsets.only(top: height*0.01),
              //            child: Row(
              //              children: [
              //                SizedBox(height: height*0.05,width: height*0.05,child: ClipRRect(borderRadius: BorderRadius.circular(height*0.02),child: Image.network(network == 'ethereum' ? ethImage : tonImage,fit: BoxFit.cover,))),
              //                SizedBox(width: width*0.03,),
              //                Text(network.toUpperCase() == 'THE-OPEN-NETWORK' ? 'TON' : network.toUpperCase(),style: TextStyle(color: Colors.white,fontSize: height*0.017,fontWeight: FontWeight.w700),),
              //              ],
              //            ),
              //          )
              //        )).toList(),
              //        value: selectedNetwork,
              //        onChanged: (String? value) {
              //          setState(() {
              //            selectedNetwork = value!;
              //          });
              //        },
              //        dropdownStyleData: DropdownStyleData(
              //          decoration: BoxDecoration(
              //            color: Colors.black,
              //            borderRadius: BorderRadius.circular(height*0.023),
              //          )
              //        ),
              //        iconStyleData: IconStyleData(
              //          icon: Icon(Icons.arrow_downward_outlined,size: height*0.02,color: Colors.white,)
              //        ),
              //      ),
              //    ),
              //  ),
              //),
              Padding(
                padding: EdgeInsets.only(bottom: height*0.03),
                child: Container(
                  alignment: Alignment.center,
                  height: height*0.38,
                  width: height*0.33,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(height*0.023),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: height*0.015),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(height*0.006),
                          child: SizedBox(
                            height: height*0.2,
                            width: height*0.2,
                            child: PrettyQrView.data(
                              data: hiveServices.wallet['tokens'][selectedNetwork]['address'],
                              decoration: PrettyQrDecoration(
                                background: Colors.white,
                                image: PrettyQrDecorationImage(
                                  image: NetworkImage(selectedNetwork == 'ethereum' ? ethImage : tonImage),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: width*0.1,left: width*0.1),
                        child: Text(hiveServices.wallet['tokens'][selectedNetwork]['address'],style: TextStyle(color: Colors.black,fontSize: height*0.015,fontWeight: FontWeight.w500),),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: height*0.045,
                width: width*0.2,
                decoration: BoxDecoration(
                  color: HexColor('1E201E'),
                  borderRadius: BorderRadius.circular(height*0.017),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/icons/copy.png',height: height*0.027,width: height*0.027,color: Colors.white,),
                    Text('Copy',style: TextStyle(color: Colors.white,fontSize: height*0.015,fontWeight: FontWeight.w600),)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height*0.03),
                child: Container(
                  padding: EdgeInsets.only(left: width*0.03,right: width*0.03),
                  alignment: Alignment.center,
                  height: height*0.04,
                  width: width*0.55,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(height*0.013),
                    border: Border.all(color: Colors.white.withOpacity(0.3),width: 0.5)
                  ),
                  child: Text('You can also receive USDT , USDC',style: TextStyle(color: Colors.white.withOpacity(0.7),fontSize: height*0.013,fontWeight: FontWeight.w300),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}