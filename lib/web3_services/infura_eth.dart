import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class EthereumService {
  final String infuraUrl = "https://mainnet.infura.io/v3/0ee62698c82a4a82a9d1acbaef3f9c06";  // Replace with your Infura project ID
  late Web3Client ethClient;

  EthereumService() {
    var httpClient = Client();
    ethClient = Web3Client(infuraUrl, httpClient);
  }

  Future<EtherAmount> getBalance(EthereumAddress address) async {
    return await ethClient.getBalance(address);
  }

  Future<String> sendTransaction(String privateKeyHex, String recipientAddressHex, double amountInEth) async {
    var credentials = EthPrivateKey.fromHex(privateKeyHex); // Your private key
    
    var recipientAddress = EthereumAddress.fromHex(recipientAddressHex); // Recipient's address

    // Convert the amount from ETH to Wei (smallest unit)
    var amountInWei = EtherAmount.fromUnitAndValue(EtherUnit.ether, BigInt.from(amountInEth*1e18));

    // Send the transaction
    var txHash = await ethClient.sendTransaction(
      credentials,
      Transaction(
        to: recipientAddress,
        value: amountInWei,
      ),
      chainId: 1, // Goerli testnet chain ID
    );

    return txHash;
  }
}
