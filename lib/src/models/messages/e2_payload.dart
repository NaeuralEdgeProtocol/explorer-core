import 'dart:convert';

import 'package:explorer_core/src/models/e2_message_new.dart';
import 'package:explorer_core/src/utils/xpand_utils.dart';

class E2Payload extends E2Message {
  E2Payload({
    required super.payloadPath,
    required super.formatter,
    required super.sign,
    required super.sender,
    required super.hash,
    required this.timestamp,
    required this.timezone,
    required this.content,
    super.messageBody,
  });

  final String timestamp;
  final String timezone;
  final Map<String, dynamic> content;

  static const List<String> mandatoryKeys = [
    'EE_PAYLOAD_PATH',
    'EE_FORMATTER',
    'EE_SIGN',
    'EE_SENDER',
    'EE_HASH',
    'EE_TIMESTAMP',
    'EE_TIMEZONE',
  ];

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'EE_TIMESTAMP': timestamp,
      'EE_TIMEZONE': timezone,
    };
  }

  static Map<String, dynamic> extractContent(Map<String, dynamic> map) {
    return Map<String, dynamic>.from(map)
      ..removeWhere((key, value) => mandatoryKeys.contains(key));
  }

  // @override
  // toString() {
  //   return jsonEncode(messageBody ?? {});
  // }

  factory E2Payload.fromJson(Map<String, dynamic> map) {
    final content = Map<String, dynamic>.from(map)
      ..removeWhere((key, value) => mandatoryKeys.contains(key));
    map = XpandUtils.decodeGzipEncryptedPayload(map);
    return E2Payload(
      payloadPath:
          (map['EE_PAYLOAD_PATH'] as List?)?.map((e) => e as String).toList() ??
              [],
      formatter: map['EE_FORMATTER'] as String?,
      sign: map['EE_SIGN'] as String?,
      sender: map['EE_SENDER'] as String?,
      hash: map['EE_HASH'] as String?,
      content: content,
      timestamp: map['EE_TIMESTAMP'] as String,
      timezone: map['EE_TIMEZONE'] as String,
      messageBody: map,
    );
  }
}
