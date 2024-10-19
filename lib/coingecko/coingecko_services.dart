import 'package:http/http.dart' as http;
import 'dart:convert';

class CoinGeckoServices {

  String key = 'CG-jsNXpXgGeg76S3ZUovZCwTJB';

  Future<List<Map<String, dynamic>>> GetTokensDetails(String coin_id) async {
    final String url = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=$coin_id';
    final response = await http.get(Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'x-cg-demo-api-key': 'CG-jsNXpXgGeg76S3ZUovZCwTJB'
      }
    );

    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to load price');
    }
  }

  Future GetByContract(String contract) async {
    final String url = 'https://api.coingecko.com/api/v3/coins/ethereum/contract/$contract';
    final response = await http.get(Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'x-cg-demo-api-key': 'CG-jsNXpXgGeg76S3ZUovZCwTJB'
      }
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load price');
    }
  }
}