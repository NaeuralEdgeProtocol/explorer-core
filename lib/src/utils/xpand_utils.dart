import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:explorer_core/src/formatter/format_decoder.dart';

class XpandUtils {
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final Random _rnd = Random();

  static String getRandomString(int length) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(
          _rnd.nextInt(_chars.length),
        ),
      ),
    );
  }

  static Map<String, dynamic> decodeGzipEncryptedPayload(
    Map<String, dynamic> data,
  ) {
    var rawData = MqttMessageEncoderDecoder.raw(data);

    var payloadPath = rawData['EE_PAYLOAD_PATH'] as List;

    if (payloadPath[1] == 'admin_pipeline' &&
        payloadPath[2] == 'UPDATE_MONITOR_01' &&
        payloadPath[3] == 'UPDATE_MONITOR_01_INST') {
      var configStartUp = rawData['CONFIG_STARTUP'];
      if (configStartUp != null) {
        var decodedConfigStartup = decodeEncryptedGzipMessage(configStartUp);
        rawData['CONFIG_STARTUP'] = decodedConfigStartup;
        return rawData;
      }
      return rawData;
    }
    return rawData;
  }

  static Map<String, dynamic> decodeGzipEnyptedHeartBeat(
    Map<String, dynamic> data,
  ) {
    var rawData = MqttMessageEncoderDecoder.raw(data);
    final bool isV2 = rawData['HEARTBEAT_VERSION'] == 'v2';
    if (rawData["EE_EVENT_TYPE"] == "HEARTBEAT" && isV2) {
      final metadataEncoded =
          XpandUtils.decodeEncryptedGzipMessage(rawData['ENCODED_DATA']);
      rawData['ENCODED_DATA'] = metadataEncoded;
      return rawData;
    }
    return rawData;
  }

  static Map<String, dynamic> decodeEncryptedGzipMessage(String base64Message) {
    final bytes = base64Decode(base64Message);
    final decodedBytes = ZLibCodec().decoder.convert(bytes);
    final decodedData = utf8.decode(decodedBytes, allowMalformed: true);
    return jsonDecode(decodedData) as Map<String, dynamic>;
  }

  static String encodeEncryptedGzipMessage(Map<String, dynamic> base64Message) {
    final prettyprint = jsonEncode(base64Message);
    final bytes = utf8.encode(prettyprint);
    final decodedBytes = ZLibCodec().encoder.convert(bytes);
    return base64.encode(decodedBytes);
  }
}
