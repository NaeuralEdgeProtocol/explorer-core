import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:explorer_core/src/ec_signature_verify/aixp_signer.dart';
import 'package:explorer_core/src/ec_signature_verify/ec_signature_verify.dart';
import 'package:explorer_core/src/ec_signature_verify/utils.dart';
import 'package:explorer_core/src/utils/constant.dart';

class AixpKeyPair {
  //TODO: Make sure isDebug is false on Release Mode
  final bool isDebug;
  AixpKeyPair({this.isDebug = false});

  final _ecInstance = EcSignatureAndVerifier();

  ECPrivateKey? privateKey;
  ECPublicKey? publicKey;

  String? initiatorId;

  /// ECPrivateKey to Hex
  String get privateKeyHex {
    return privateKey!.d!.toRadixString(16).padLeft(64, '0');
  }

  String get privateKeyPem {
    return CryptoUtils.encodeEcPrivateKeyToPem(privateKey!);
  }

  /// ECPublicKey to CompressedHex
  String get publicKeyHexCompressed =>
      _ecInstance.compressPublicKey(publicKey!);

  ///Wallet Address From Public Key
  String get walletAddress => _ecInstance.getAddressFromPublicKey(publicKey!);

  String get addressToShow {
    return minimfyAdddressToShow(walletAddress);
  }

  createInitiaorId() {
    initiatorId =
        Constant.INITIATORIDPREFIX + Random().nextIntOfDigits(6).toString();
  }

  bool createKeypair() {
    try {
      print("----- Create KeyPair------ \n\n");
      var keyPair = _ecInstance.generateSecp256k1KeyPair();
      privateKey = keyPair.privateKey as ECPrivateKey;
      publicKey = keyPair.publicKey as ECPublicKey;
      createInitiaorId();
      consoleKeyInfo();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  consoleKeyInfo() {
    if (isDebug) {
      final publicKeyCompredHex = _ecInstance.compressPublicKey(publicKey!);
      print("---------  Private Key Hex-----");
      print("${privateKeyHex} \n\n");
      print("---------   Private Key Unit8List -----");
      print("${HexUtils.decode(privateKeyHex)} \n\n");
      print("---------  Private key Pem -----");
      print("$privateKeyPem \n\n");

      print("--------- Public Key Compresed Hex -----");
      print("$publicKeyCompredHex \n\n");
      print("---------  Address -----");
      print(" ${_ecInstance.getAddressFromPublicKey(publicKey!)} \n\n");
    }
  }

  Map<String, dynamic> signMessage(Map<String, dynamic> data) {
    final signedMessage = AixpSigner(privateKey: privateKey!).signMessage(
      data,
      walletAddress,
    );
    return signedMessage;
  }

  bool loadKeypair(String privateKeyPem) {
    try {
      privateKey = CryptoUtils.ecPrivateKeyFromPem(privateKeyPem);
      publicKey = _ecInstance.derivePublicKey(privateKey!);
      createInitiaorId();
      consoleKeyInfo();
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
