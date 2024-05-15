import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:explorer_core/src/ec_signature_verify/aixp_verifier.dart';
import 'package:explorer_core/src/ec_signature_verify/ec_signature_verify.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:crypto/crypto.dart';

class AixpSigner {
  final ECPrivateKey privateKey;

  AixpSigner({required this.privateKey});
  ECPublicKey? publicKey;

  final _ecInstance = EcSignatureAndVerifier();

  String sign(String message) {
    try {
      String signature = _ecInstance.signHashToBase64(message, privateKey);
      return signature;
    } catch (e) {
      rethrow;
    }
  }

// Input: message Map<String,dynamic>
// Perform: Sign a message string with our private key
// Returns: Return signed message
  Map<String, dynamic> signMessage(
    Map<String, dynamic> message,
    String addrress,
  ) {
    ///Re-arranging Map in a alphaptical & lexical  oufer
    final cleanedMap = CustomJsonEncoder.cleanedAndRearrangedMap(message);

    /// Data being hashed
    var bytes = utf8.encode(jsonEncode(cleanedMap));
    var digest = sha256.convert(bytes);
    String hashHexEE = digest.toString();

    try {
      String signatureEE = _ecInstance.signHashToBase64(hashHexEE, privateKey);
      return CustomJsonEncoder.cleanedAndRearrangedMap({
        ...message,
        "EE_SIGN": signatureEE,
        "EE_HASH": hashHexEE,
        "EE_SENDER": addrress,
      });
    } catch (e) {
      rethrow;
    }
  }
}
