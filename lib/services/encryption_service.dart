import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:uuid/uuid.dart';

class EncryptionService {
  // AES encryption key (should be securely stored or generated per session)
  static final String _key = '1234567890123456'; // 16 bytes key for AES-128
  static final String _iv = '1234567890123456'; // 16 bytes IV for AES-128

  // Encrypt data using AES encryption
  static String encryptData(String plainText) {
    final key = encrypt.Key.fromUtf8(_key);
    final iv = encrypt.IV.fromUtf8(_iv);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    // Encrypt the data
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  // Decrypt data using AES decryption
  static String decryptData(String encryptedText) {
    final key = encrypt.Key.fromUtf8(_key);
    final iv = encrypt.IV.fromUtf8(_iv);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    // Decrypt the data
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }

  // Generate a random string for use as a salt or session key
  static String generateSalt() {
    final uuid = Uuid();
    return uuid.v4(); // Generate a unique identifier as salt
  }

  // Hash data using SHA256 (e.g., for passwords, etc.)
  static String hashData(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Hash data and then encrypt it using AES
  static String hashAndEncryptData(String input) {
    String hashedInput = hashData(input);
    return encryptData(hashedInput);
  }

  // Example: Encrypt and decrypt a message (could be used for messages in chat)
  static String encryptMessage(String message) {
    // Encrypt message using AES
    return encryptData(message);
  }

  static String decryptMessage(String encryptedMessage) {
    // Decrypt message using AES
    return decryptData(encryptedMessage);
  }
}
