import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test/coingecko/coingecko_services.dart';
import 'package:test/local_storage/hive_services.dart';
import 'package:test/web3_services/alchemy_eth.dart';
import 'package:test/web3_services/ton_services.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {

  List transactions = [];

  HiveServices hiveServices = HiveServices();
  CoinGeckoServices coinGeckoServices = CoinGeckoServices();
  AlchemyEth alchemyEth = AlchemyEth();
  TonServices tonServices = TonServices();


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black,),
      body: FutureBuilder(
        future: convertAndsaveData(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
             padding: EdgeInsets.only(right: width*0.05,left: width*0.05,bottom: height*0.1),
             child: Container(
              decoration: BoxDecoration(
                color: HexColor('1E201E'),
                borderRadius: BorderRadius.circular(height*0.023),
              ),
               child: Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.white,
                 child: ListView.builder(
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: height*0.1,
                            padding: EdgeInsets.only(left: width*0.03,top: height*0.02, bottom: height*0.02,right: width*0.03),
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(width: width*0.2,height: height*0.025,decoration: BoxDecoration(color: Colors.grey.withOpacity(0.7),borderRadius: BorderRadius.circular(height*0.007)),),
                                    Padding(
                                      padding: EdgeInsets.only(left: width*0.01),
                                      child: Container(width: width*0.13,height: height*0.025,decoration: BoxDecoration(color: Colors.grey.withOpacity(0.7),borderRadius: BorderRadius.circular(height*0.007)),),
                                    ),
                                    Expanded(
                                      child: SizedBox(width: 1,),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      height: height*0.025,
                                      width: width*0.13,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(height*0.007),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(width: 1,),
                                    ),
                                    Container(width: width*0.2,height: height*0.025,decoration: BoxDecoration(color: Colors.grey.withOpacity(0.7),borderRadius: BorderRadius.circular(height*0.007)),),
                                    Padding(
                                      padding: EdgeInsets.only(left: width*0.01),
                                      child: Container(width: width*0.13,height: height*0.025,decoration: BoxDecoration(color: Colors.grey.withOpacity(0.7),borderRadius: BorderRadius.circular(height*0.007)),),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: height*0.025,
                                      width: width*0.15,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(height*0.007),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: width*0.01),
                                      child: Container(width: width*0.1,height: height*0.025,decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2),borderRadius: BorderRadius.circular(height*0.007)),),
                                    ),
                                    Expanded(flex: 1,child: SizedBox(width: 1,)),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(right: width*0.02,left: width*0.02),
                                      height: height*0.025,
                                      width: width*0.3,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(height*0.007),
                                      ),
                                    ),
                                    Expanded(flex: 5,child: SizedBox(width: 1,)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if(index != 6) Divider(color: Colors.white.withOpacity(0.2),),
                        ],
                      ),
                    );
                    },
                  ),
               ),
             ),
           );
          } else if(snapshot.hasData) {
            return Padding(
             padding: EdgeInsets.only(right: width*0.05,left: width*0.05,bottom: height*0.1),
             child: Container(
              height: snapshot.data.length*(height*0.058),
              decoration: BoxDecoration(
                color: HexColor('1E201E'),
                borderRadius: BorderRadius.circular(height*0.023),
              ),
               child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final transaction = snapshot.data[index];
                  return transaction['out_msgs'].isEmpty ? transaction['in_msg']['source'] != "" ? GestureDetector(
                    onTap: () {
                      print(transaction['out_msgs']);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: height*0.1,
                          padding: EdgeInsets.only(left: width*0.03,top: height*0.02, bottom: height*0.02,right: width*0.03),
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(width: width*0.2,child: Text('${transaction['in_msg']['source']}',style: TextStyle(color: Colors.white,fontSize: height*0.017,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)),
                                  SizedBox(width: width*0.13,child: Text('${transaction['in_msg']['source'][transaction['in_msg']['source'].toString().length-5]}${transaction['in_msg']['source'][transaction['in_msg']['source'].toString().length-4]}${transaction['in_msg']['source'][transaction['in_msg']['source'].toString().length-3]}${transaction['in_msg']['source'][transaction['in_msg']['source'].toString().length-2]}${transaction['in_msg']['source'][transaction['in_msg']['source'].toString().length-1]}',style: TextStyle(color: Colors.white,fontSize: height*0.017,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)),
                                  Expanded(
                                    child: SizedBox(width: 1,),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: height*0.025,
                                    width: width*0.13,
                                    decoration: BoxDecoration(
                                      color: HexColor('41C9E2').withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(height*0.007),
                                    ),
                                    child: Text('IN',style: TextStyle(color: HexColor('359EAC')),),
                                  ),
                                  Expanded(
                                    child: SizedBox(width: 1,),
                                  ),
                                  SizedBox(width: width*0.2,child: Text('${transaction['in_msg']['destination']}',style: TextStyle(color: Colors.white,fontSize: height*0.017,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)),
                                  SizedBox(width: width*0.13,child: Text('${transaction['in_msg']['destination'][transaction['in_msg']['destination'].toString().length-5]}${transaction['in_msg']['destination'][transaction['in_msg']['destination'].toString().length-4]}${transaction['in_msg']['destination'][transaction['in_msg']['destination'].toString().length-3]}${transaction['in_msg']['destination'][transaction['in_msg']['destination'].toString().length-2]}${transaction['in_msg']['destination'][transaction['in_msg']['destination'].toString().length-1]}',style: TextStyle(color: Colors.white,fontSize: height*0.017,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: height*0.025,
                                    width: width*0.18,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(height*0.007),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Transform.rotate(angle: 1.5,child: Icon(Icons.arrow_outward_outlined,size: height*0.015,color: Colors.white,)),
                                        SizedBox(width: 3,),
                                        Text('Receive',style: TextStyle(color: Colors.white,fontSize: height*0.015,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Text('  ${double.parse(transaction['in_msg']['value']) / 1000000000} TON',style: TextStyle(color: Colors.white,fontSize: height*0.015,fontWeight: FontWeight.bold)),
                                  Expanded(flex: 1,child: SizedBox(width: 1,)),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(right: width*0.02,left: width*0.02),
                                    height: height*0.025,
                                    width: transaction['in_msg']['message'] != "" ? width*0.3 : 0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(height*0.007),
                                    ),
                                    child: Text('${transaction['in_msg']['message']}',style: TextStyle(color: Colors.white,fontSize: height*0.015,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                                  ),
                                  Expanded(flex: 5,child: SizedBox(width: 1,)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if(index != (snapshot.data.length - 1)) Divider(color: Colors.white.withOpacity(0.2),),
                      ],
                    ),
                  ) : Container() : GestureDetector(
                    onTap: () {
                      print(transaction['out_msgs']);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: height*0.1,
                          padding: EdgeInsets.only(left: width*0.03,top: height*0.02, bottom: height*0.02,right: width*0.03),
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(width: width*0.2,child: Text('${transaction['out_msgs'][0]['source']}',style: TextStyle(color: Colors.white,fontSize: height*0.017,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)),
                                  SizedBox(width: width*0.13,child: Text('${transaction['out_msgs'][0]['source'][transaction['out_msgs'][0]['source'].toString().length-5]}${transaction['out_msgs'][0]['source'][transaction['out_msgs'][0]['source'].toString().length-4]}${transaction['out_msgs'][0]['source'][transaction['out_msgs'][0]['source'].toString().length-3]}${transaction['out_msgs'][0]['source'][transaction['out_msgs'][0]['source'].toString().length-2]}${transaction['out_msgs'][0]['source'][transaction['out_msgs'][0]['source'].toString().length-1]}',style: TextStyle(color: Colors.white,fontSize: height*0.017,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)),
                                  Expanded(
                                    child: SizedBox(width: 1,),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: height*0.025,
                                    width: width*0.13,
                                    decoration: BoxDecoration(
                                      color: HexColor('AC355B').withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(height*0.007),
                                    ),
                                    child: Text('OUT',style: TextStyle(color: HexColor('FF6D9C')),),
                                  ),
                                  Expanded(
                                    child: SizedBox(width: 1,),
                                  ),
                                  SizedBox(width: width*0.2,child: Text('${transaction['out_msgs'][0]['destination']}',style: TextStyle(color: Colors.white,fontSize: height*0.017,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)),
                                  SizedBox(width: width*0.13,child: Text('${transaction['out_msgs'][0]['destination'][transaction['out_msgs'][0]['destination'].toString().length-5]}${transaction['out_msgs'][0]['destination'][transaction['out_msgs'][0]['destination'].toString().length-4]}${transaction['out_msgs'][0]['destination'][transaction['out_msgs'][0]['destination'].toString().length-3]}${transaction['out_msgs'][0]['destination'][transaction['out_msgs'][0]['destination'].toString().length-2]}${transaction['out_msgs'][0]['destination'][transaction['out_msgs'][0]['destination'].toString().length-1]}',style: TextStyle(color: Colors.white,fontSize: height*0.017,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: height*0.025,
                                    width: width*0.15,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(height*0.007),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.arrow_outward_outlined,size: height*0.015,color: Colors.white,),
                                        SizedBox(width: 3,),
                                        Text('Sent',style: TextStyle(color: Colors.white,fontSize: height*0.015,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Text('  ${double.parse(transaction['out_msgs'][0]['value']) / 1000000000} TON',style: TextStyle(color: Colors.white,fontSize: height*0.015,fontWeight: FontWeight.bold)),
                                  Expanded(flex: 1,child: SizedBox(width: 1,)),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(right: width*0.02,left: width*0.02),
                                    height: height*0.025,
                                    width: transaction['out_msgs'][0]['message'] != "" ? width*0.3 : 0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(height*0.007),
                                    ),
                                    child: Text('${transaction['out_msgs'][0]['message']}',style: TextStyle(color: Colors.white,fontSize: height*0.015,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                                  ),
                                  Expanded(flex: 5,child: SizedBox(width: 1,)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if(index != (snapshot.data.length - 1)) Divider(color: Colors.white.withOpacity(0.2),),
                      ],
                    ),
                  );
                },
              ),
             ),
           );
          } else {
            return Center(
              child: SizedBox(height: height*0.3,width: height*0.3,child: SvgPicture.asset('assets/svg/Empty street-bro.svg')),
            );
          }
        }
      )
    );
  }

  String formatUnixTime(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return dateTime.toLocal().toString();
  }

  Future convertAndsaveData() async {
    return await tonServices.getTransactions();
  }

}