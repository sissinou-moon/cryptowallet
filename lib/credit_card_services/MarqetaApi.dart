import 'dart:convert';
import 'package:http/http.dart' as http;

class MarqetaApi {
  final String applicationToken = '22beaff2-27fa-46e9-b84e-0a240bcca9d8';
  final String adminAccessToken = '7c98bca9-bc1a-4f5d-a717-502a1fc25d32'; // Admin Access Token
  final String baseUrl = 'https://sandbox-api.marqeta.com/v3/';

  Future<String?> createUser(String firstName, String lastName) async {
    final String url = '${baseUrl}users';

    final Map<String, dynamic> body = {
      "first_name": firstName,
      "last_name": lastName,
      // Add any other required fields based on your use case
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Basic MjJiZWFmZjItMjdmYS00NmU5LWI4NGUtMGEyNDBiY2NhOWQ4OjdjOThiY2E5LWJjMWEtNGY1ZC1hNzE3LTUwMmExZmMyNWQzMg==',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('User Created Successfully: ${data}');
      return data['token']; // Return the user token
    } else {
      print('Failed to create user: ${response.statusCode} ${response.body}');
      return null;
    }
  }


  Future<void> getCardProducts() async {
    final String url = '${baseUrl}cardproducts?sort_by=-lastModifiedTime';

    // Use Basic Auth for the application token and admin access token
    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('$applicationToken:$adminAccessToken'));

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': basicAuth, // Use Basic Authentication
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Card Products Retrieved Successfully: ${data}');
    } else {
      print('Failed to retrieve card products: ${response.statusCode} ${response.body}');
    }
  }


  Future<String> GetCardProductToken() async {
    final url = 'https://sandbox-api.marqeta.com/v3/cardproducts';

    // Use Basic Auth for the application token and admin access token
    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('$applicationToken:$adminAccessToken'));

    final response = await http.get(Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Basic MjJiZWFmZjItMjdmYS00NmU5LWI4NGUtMGEyNDBiY2NhOWQ4OjdjOThiY2E5LWJjMWEtNGY1ZC1hNzE3LTUwMmExZmMyNWQzMg=='
      }
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'][0]['token'];
    } else {
      print('Failed to get card product token: ${response.statusCode} ${response.body}');
      return '';
    }
  }

  Future<void> createVirualCard(String userToken, String cardProductToken) async {
    final url = 'https://sandbox-api.marqeta.com/v3/cards?show_cvv_number=true&show_pan=true';

    // Create the request body for the card
    final Map<String, dynamic> body = {
      "card_product_token": cardProductToken,
      "user_token": userToken,
      "fulfillment": {
        "shipping": {
          "recipient_address": {
            "address1": "123 Main St",
            "address2": "Apt 4B", // Optional
            "city": "New York",
            "state": "NY",
            "postal_code": "10001",
            "country": "US",
            "first_name": "John",
            "last_name": "Doe",
            "phone": "1234567890"
          },
          // Optional: You can also add a return address if needed
          // "return_address": {
          //   "address1": "456 Return St",
          //   "city": "New York",
          //   "state": "NY",
          //   "postal_code": "10001",
          //   "country": "US"
          // }
        }
      }
    };

    final response = await http.post(Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Basic MjJiZWFmZjItMjdmYS00NmU5LWI4NGUtMGEyNDBiY2NhOWQ4OjdjOThiY2E5LWJjMWEtNGY1ZC1hNzE3LTUwMmExZmMyNWQzMg=='
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('Virtual Card Created Successfully: ${data}');
    } else {
      print('Failed to create virtual card: ${response.statusCode} ${response.body}');
    }

  }
}
