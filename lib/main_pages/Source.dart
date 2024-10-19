import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:test/card_pages/Card.dart';
import 'package:test/main_pages/Home.dart';
import 'package:test/main_pages/Transactions.dart';

class SourcePage extends StatefulWidget {
  const SourcePage({super.key});

  @override
  State<SourcePage> createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> {

  int index = 0;

  List<Widget> pages = [
    WalletHomePage(),
    CardPage(),
    TransactionsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: pages[index],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: height*0.02,right: width*0.2,left: width*0.2),
        child: Container(
          padding: EdgeInsets.only(right: width*0.045,left: width*0.045),
          height: height*0.07,
          decoration: BoxDecoration(
            color: HexColor('1E201E'),
            borderRadius: BorderRadius.circular(height*0.023),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 0;
                  });
                },
                child: SizedBox(
                  height: height*0.027,
                  width: height*0.027,
                  child: index == 0 ? Image.asset('assets/icons/homefill.png',color: HexColor('41C9E2'),) : Image.asset('assets/icons/home_outline.png',color: Colors.white54,)
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 1;
                  });
                },
                child: SizedBox(
                  height: height*0.031,
                  width: height*0.031,
                  child: index == 1 ? Image.asset('assets/icons/creditCard.png',color: HexColor('41C9E2'),) : Image.asset('assets/icons/craditCard_outline.png',color: Colors.white54,)
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 2;
                  });
                },
                child: SizedBox(
                  height: height*0.027,
                  width: height*0.027,
                  child: index == 2 ? Image.asset('assets/icons/receiptfill.png',color: HexColor('41C9E2'),) : Image.asset('assets/icons/receipt_outline.png',color: Colors.white54,)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}