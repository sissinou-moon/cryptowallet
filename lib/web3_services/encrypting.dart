import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptingData {
  // Encrypt data and return both encrypted data and IV
  static Map<String, String> encryptData(String data, String key) {
    final _key = encrypt.Key.fromBase64(key);
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final iv = encrypt.IV.fromLength(16); // Generate a random IV

    // Encrypt the data
    final encryptedData = encrypter.encrypt(data, iv: iv).base64;

    // Return both encrypted data and IV
    return {
      'encryptedData': encryptedData,
      'iv': iv.base64,
      'key': key,
    };
  }

  // Decrypt data using the encrypted data and the IV
  static String decryptData(String encryptedData, String iv, String key) {
    final _key = encrypt.Key.fromBase64(key);
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final ivInstance = encrypt.IV.fromBase64(iv); // Use the stored IV
    return encrypter.decrypt64(encryptedData, iv: ivInstance);
  }
}

