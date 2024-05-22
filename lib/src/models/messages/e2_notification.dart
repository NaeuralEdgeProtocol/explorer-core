import 'package:explorer_core/src/formatter/format_decoder.dart';
import 'package:explorer_core/src/models/e2_message_new.dart';

class E2Notification extends E2Message {
  final Map<String, dynamic> data;
  final String? notification;
  final int? notificationCode;
  final String? notificationTag;
  final String? notificationType;

  E2Notification({
    required super.payloadPath,
    required super.formatter,
    required super.sign,
    required super.sender,
    required super.hash,
    required this.data,
    super.messageBody,
    required this.notification,
    required this.notificationCode,
    required this.notificationTag,
    required this.notificationType,
  });

  factory E2Notification.fromMap(Map<String, dynamic> map) {
    map = MqttMessageEncoderDecoder.raw(map);
    return E2Notification(
      payloadPath: (map['EE_PAYLOAD_PATH'] as List?)
              ?.map((e) => e as String?)
              .toList() ??
          [],
      formatter: map['EE_FORMATTER'] as String?,
      sign: map['EE_SIGN'] as String?,
      sender: map['EE_SENDER'] as String?,
      hash: map['EE_HASH'] as String?,
      data: map,
      notification: map['NOTIFICATION'] ?? map['NOTIFICATION'].toString(),
      notificationCode: map['NOTIFICATION_CODE'],
      notificationTag:
          map['NOTIFICATION_TAG'] ?? map['NOTIFICATION_TAG'].toString(),
      notificationType:
          map['NOTIFICATION_TYPE'] ?? map['NOTIFICATION_TYPE'].toString(),
      messageBody: map,
    );
  }
}
