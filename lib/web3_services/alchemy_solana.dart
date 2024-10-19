import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:solana/solana.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';

class SolanaService {
  final RpcClient solanaClient;

  // Initialize the Solana RPC client with Alchemy's URL
  SolanaService(String rpcUrl)
      : solanaClient = RpcClient(rpcUrl);  // Only pass the RPC URL

  // Method to check the balance of a Solana account
  Future<void> getBalance(String publicKey) async {
    try {
      // Fetch the balance in lamports (BigInt)
      final lamports = await solanaClient.getBalance(publicKey);

      // Convert lamports to SOL (1 SOL = 1e9 lamports)
      final double solBalance = lamports.value.toDouble() / 1e9;

      print('Balance: $solBalance SOL');
    } catch (e) {
      print('Failed to fetch balance: $e');
    }
  }

}
