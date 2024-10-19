import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:tonutils/tonutils.dart';

class TonServices {
  final apikey = '8ca8cb418abf8387ea965e5a338aa2f3b13ae5a548e82e5ae244cd842cf592d1';
  final testnetClient = TonJsonRpc(); // Connects to testnet by default
  final client = TonJsonRpc('https://toncenter.com/api/v2/jsonRPC'); // Connects to mainnet

  Future<double> getBalance(Uint8List publicKey) async {

    // But you can specify an alternative endpoint, say, for mainnet:
    final client = TonJsonRpc('https://toncenter.com/api/v2/jsonRPC');

    // Wallet contracts use workchain = 0, but this can be overriden
    var wallet = WalletContractV4R2.create(publicKey: publicKey);

    // Opening a wallet contract (this specifies the TonJsonRpc as a ContractProvider)
    var openedContract = client.open(wallet);

    // Get the balance of the contract
    var balance = (await openedContract.getBalance()).toDouble() / 1000000000;

    return balance;
  }

  Future sendTonTransaction(Uint8List publicKey, Uint8List privateKey, String receiverAddress, String amount) async {

    var wallet = WalletContractV4R2.create(publicKey: publicKey);
    var openedContract = client.open(wallet);

    var seqno = await openedContract.getSeqno();

    try {
      print('address : $receiverAddress');
      await openedContract.send(openedContract.createTransfer(
        seqno: seqno, 
        privateKey: privateKey, 
        messages: [
          internal(
            to: SiaString(receiverAddress), 
            value: SbiString(amount),
            body: ScString('Hello, from versili app!'),
          )
        ]
      ));

      print('done');
    } catch (e) {
      throw Exception('Faild to execute this transaction <sendTonTransaction> : $e');
    }
  }


  Future getTransactions() async {
    final url = 'https://go.getblock.io/873d270c443b408c831dc1fb54559be3/getTransactions?address=EQBE7h6eRLkNJq9edGjr7qaA_1Rv0LxKUwwU86xrvV3evfvh&limit=11';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['result'];
      } else {
        print('Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


}