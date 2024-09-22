import 'package:encrypt/encrypt.dart' as encrypt;

class Encrypting {
  String encryptData(String data, String key) {
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(key)));
    final encrypted = encrypter.encrypt(data, iv: encrypt.IV.fromLength(16));
    return encrypted.base64;
  }
  
  String decryptData(String encryptedData, String key) {
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(key)));
    final decrypted = encrypter.decrypt64(encryptedData, iv: encrypt.IV.fromLength(16));
    return decrypted;
  }
}
