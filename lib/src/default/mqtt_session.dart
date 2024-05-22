import 'dart:async';
import 'dart:convert';
import 'package:explorer_core/explorer_core.dart';
import 'package:explorer_core/src/base/generic_session.dart';
import 'package:explorer_core/src/comm/mqtt_wrapper.dart';
import 'package:explorer_core/src/commands/e2_commands.dart';
import 'package:explorer_core/src/const/mqtt_config.dart';
import 'package:explorer_core/src/ec_signature_verify/aixp_verifier.dart';
import 'package:explorer_core/src/formatter/format_decoder.dart';
import 'package:explorer_core/src/models/e2_box.dart';
import 'package:explorer_core/src/models/messages/e2_heartbeat.dart';
import 'package:explorer_core/src/models/messages/e2_notification.dart';
import 'package:explorer_core/src/models/messages/e2_payload.dart';
import 'package:explorer_core/src/models/utils_models/e2_heartbeat.dart';

class MqttSession extends GenericSession {
  /// Message Veirifer
  final aixpVerifier = AixpVerifier(isDebug: false);

  MqttSession({
    required super.server,
    void Function(E2Heartbeat)? onHeartbeat,
    void Function(E2Notification)? onNotification,
    void Function(E2Payload)? onPayload,

    /// This at is triggered for any of the 3 mqttWrappers objects
    /// Should be 3 different parameters?
    void Function(bool connectionStatus)? onConnectionStatusChanged,
    // VoidCallback? onBoxConnected,
    Function? onBoxConnected,
  }) : super(
          onHeartbeat: onHeartbeat ?? _defaultOnHeartbeat,
          onNotification: onNotification ?? _defaultOnNotification,
          onPayload: onPayload ?? _defaultOnPayload,
        ) {
    _payloadMqtt = MqttWrapper(
      server: server,
      receiveChannelName: MqttConfig.payloadsChannelTopic,
      sendChannelName: MqttConfig.configChannelTopic,
      onConnectionStatusChanged: onConnectionStatusChanged,
    );
    _heartbeatMqtt = MqttWrapper(
      server: server,
      receiveChannelName: MqttConfig.controlChannelTopic,
      onConnectionStatusChanged: onConnectionStatusChanged,
    );
    _notificationMqtt = MqttWrapper(
      server: server,
      receiveChannelName: MqttConfig.notificationChannelTopic,
      onConnectionStatusChanged: onConnectionStatusChanged,
    );
  }

  late final MqttWrapper _payloadMqtt;
  late final MqttWrapper _heartbeatMqtt;
  late final MqttWrapper _notificationMqtt;
  StreamController<Map<String, dynamic>>? _payloadReceiveStream;
  StreamController<Map<String, dynamic>>? _heartbeatReceiveStream;
  StreamController<Map<String, dynamic>>? _notificationReceiveStream;

  bool get isHeartbeatConnected => _heartbeatMqtt.isConnected;
  bool get isNotificationConnected => _notificationMqtt.isConnected;
  bool get isPayloadConnected => _payloadMqtt.isConnected;

  @override
  bool get isConnected =>
      isHeartbeatConnected && isNotificationConnected && isPayloadConnected;

  /// Sends a command to a specific box.
  @override
  void sendCommand(E2Command command) {
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(command.signedMap());
    // print(
    //     "Sent command on lummetry/${command.targetId}/config: \n\n$prettyprint");

    _payloadMqtt.sendOnTopic(
      command.toJson(),
      'lummetry/${command.targetId}/config',
    );
  }

  @override
  Future<void> connect() async {
    /// Could abstract everything??
    /// Heartbeat connect
    _heartbeatReceiveStream = StreamController<Map<String, dynamic>>();
    _heartbeatReceiveStream?.stream.listen((message) {
      var messageVerifier = aixpVerifier.verifyMessage(message);
      if (messageVerifier) {
        onHeartbeat(E2Heartbeat.fromMap(message));
      }
    });
    await _heartbeatMqtt.serverConnect(receiveStream: _heartbeatReceiveStream);
    _heartbeatMqtt.subscribe();

    /// Notification connect
    _notificationReceiveStream = StreamController<Map<String, dynamic>>();
    _notificationReceiveStream?.stream.listen((message) {
      var messageVerifier = aixpVerifier.verifyMessage(message);
      if (messageVerifier) {
        onNotification(E2Notification.fromMap(message));
      }
    });
    await _notificationMqtt.serverConnect(
      receiveStream: _notificationReceiveStream,
    );
    _notificationMqtt.subscribe();

    /// Payload (Default communicator) connect
    _payloadReceiveStream = StreamController<Map<String, dynamic>>();
    _payloadReceiveStream?.stream.listen((message) {
      var messageVerifier = aixpVerifier.verifyMessage(message);
      if (messageVerifier) {
        onPayload(E2Payload.fromJson(message));
      }
    });
    await _payloadMqtt.serverConnect(receiveStream: _payloadReceiveStream);
    _payloadMqtt.subscribe();
  }

  @override
  Future<void> close() async {
    _heartbeatMqtt.disconnect();
    if (_heartbeatReceiveStream != null) {
      await _heartbeatReceiveStream!.close();
    }

    /// Notif close
    _notificationMqtt.disconnect();
    if (_notificationReceiveStream != null) {
      await _notificationReceiveStream!.close();
    }

    /// Payload close
    _payloadMqtt.disconnect();
    if (_payloadReceiveStream != null) {
      await _payloadReceiveStream!.close();
    }
  }

  void _onHeartbeatInternal(Map<String, dynamic> message) {
    try {
      final boxName = message['EE_ID'];

      final timeNow = DateTime.now();
      if (boxes.containsKey(boxName)) {
        boxes[boxName]!.isOnline = true;
        boxes[boxName]!.lastHbReceived = timeNow;
      } else {
        boxes[boxName] =
            E2Box(name: boxName, isOnline: true, lastHbReceived: timeNow);
      }
      // onHeartbeat.call(message);
    } catch (_, s) {
      print('Invalid heartbeat received $s');
      // print(s);
    }
  }

  static void _defaultOnHeartbeat(E2Heartbeat message) {
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(message);

    print('Received heartbeat message: <--\n $prettyprint \n-->');
    print('');
  }

  static void _defaultOnNotification(E2Notification notification) {
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(notification.messageBody);

    print('Received notification message: <--\n $prettyprint \n-->');
    print('');
  }

  static void _defaultOnPayload(E2Payload message) {
    print('Received payload message');
    // print(jsonEncode(message));
  }
}
