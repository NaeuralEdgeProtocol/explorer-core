import 'package:explorer_core/src/models/e2_message_new.dart';
import 'package:explorer_core/src/utils/xpand_utils.dart';

class E2Heartbeat extends E2Message {
  E2Heartbeat({
    required super.payloadPath,
    required super.formatter,
    required super.sign,
    required super.sender,
    required super.hash,
    required this.timestamp,
    required this.timezone,
    required this.totalMessages,
    required this.messageId,
    required this.heartbeatVersion,
    this.deviceStatus,
    this.encodedData,
    super.messageBody,
  });

  final String timestamp;
  final String timezone;
  final int totalMessages;
  final String messageId;
  final String? deviceStatus;
  final String heartbeatVersion;

  final Map<String, dynamic>? encodedData;

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'EE_TIMESTAMP': timestamp,
      'EE_TIMEZONE': timezone,
      'EE_TOTAL_MESSAGES': totalMessages,
      'EE_MESSAGE_ID': messageId,
      'HEARTBEAT_VERSION': heartbeatVersion,
      'ENCODED_DATA': encodedData,
    };
  }

  factory E2Heartbeat.fromMap(Map<String, dynamic> map) {
    map = XpandUtils.decodeGzipEnyptedHeartBeat(map);
    return E2Heartbeat(
      payloadPath:
          (map['EE_PAYLOAD_PATH'] as List).map((e) => e as String?).toList(),
      formatter: map['EE_FORMATTER'] as String?,
      sign: map['EE_SIGN'] as String,
      sender: map['EE_SENDER'] as String,
      hash: map['EE_HASH'] as String,
      timestamp: map['EE_TIMESTAMP'] as String,
      timezone: map['EE_TIMEZONE'] as String,
      totalMessages: map['EE_TOTAL_MESSAGES'] as int,
      messageId: map['EE_MESSAGE_ID'],
      deviceStatus: map['DEVICE_STATUS'] as String?,
      messageBody: map,
      heartbeatVersion: map['HEARTBEAT_VERSION'] as String,
      encodedData: map['ENCODED_DATA'] as Map<String, dynamic>?,
    );
  }
}
