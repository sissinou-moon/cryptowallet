import 'package:http/http.dart' as http;
import 'dart:convert';

class AlchemyEth {
  final String apiKey = 'blDa7IybuNsPEL8Uv-TdcjXWmwCATVRZ';
  final url = 'https://eth-mainnet.g.alchemy.com/v2/blDa7IybuNsPEL8Uv-TdcjXWmwCATVRZ';
  final header = {
    'accept': 'application/json',
    'content-type': 'application/json',
  };

  Future<double> getEthBalance(String walletAddress) async {
    Map<String, dynamic> requestPayload = {"id": 1, "jsonrpc": "2.0","params":["$walletAddress","latest"],"method": "eth_getBalance"};
    final response = await http.post(Uri.parse(url),
      headers: header,
      body: jsonEncode(requestPayload)
    );
    if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String weiBalanceHex = data['result'];  // Balance in Wei (Hex)
        final BigInt weiBalance = BigInt.parse(weiBalanceHex.substring(2), radix: 16);
        final double ethBalance = weiBalance / BigInt.from(10).pow(18);  // Convert from Wei to ETH
        return ethBalance;
    } else {
      throw Exception('Faild to load eth balance');
    }
  }


  Future getERC20Tokens(String walletAddress) async {
    Map<String, dynamic> requestPayload = {
      "id": 1,
      "jsonrpc": "2.0",
      "method": "alchemy_getTokenBalances",
      "params": [
        walletAddress,
      ]
    };
    try {
      final response = await http.post(Uri.parse(url),
        headers: header,
        body: jsonEncode(requestPayload)
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['result']['tokenBalances'].toList();
      } else {
        throw Exception('Faild to load tokens in ERC-20');
      }
    } catch (e) {
      print(e);
    }
  }


  Future getTokensByContractAddress(String contracts) async {
    Map<String, dynamic> requestPayload = {
      'id': 1,
      "jsonrpc": "2.0",
      "method": "alchemy_getTokenMetadata",
      "params": [
        contracts,
      ]
    };
    final response = await http.post(Uri.parse(url),
      headers: header,
      body: jsonEncode(requestPayload)
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['result'];
    } else {
      throw Exception('Faild to load Token Metadata <Alchemy> ');
    }
  }
}