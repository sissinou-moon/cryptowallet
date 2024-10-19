import 'package:flutter/material.dart';
import 'package:test/credit_card_services/MarqetaApi.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {


  MarqetaApi marqetaApi = MarqetaApi();
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black,),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              FullSteps();
            },
            child: Container(
              height: height*0.065,
              width: width*0.2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(height*0.023),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void FullSteps() async  {
    String? userToken = await marqetaApi.createUser('John', 'Doe');
    if (userToken != null) {
      print('User Token: $userToken');
    }

    String cardProductToken = await marqetaApi.GetCardProductToken();

    print('Card Product Token: $cardProductToken');

    await marqetaApi.createVirualCard(userToken!, cardProductToken);
  }

}