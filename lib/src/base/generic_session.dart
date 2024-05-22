import 'package:explorer_core/explorer_core.dart';
import 'package:explorer_core/src/commands/e2_commands.dart';
import 'package:explorer_core/src/models/e2_box.dart';
import 'package:explorer_core/src/models/messages/e2_heartbeat.dart';
import 'package:explorer_core/src/models/messages/e2_notification.dart';
import 'package:explorer_core/src/models/mqtt_server.dart';
import 'package:explorer_core/src/models/utils_models/e2_heartbeat.dart';

abstract class GenericSession {
  GenericSession({
    required this.server,
    required this.onHeartbeat,
    required this.onNotification,
    required this.onPayload,
  });

  final MqttServer server;
  final void Function(E2Heartbeat) onHeartbeat;
  final void Function(E2Notification) onNotification;
  final void Function(E2Payload) onPayload;

  final Map<String, E2Box> boxes = <String, E2Box>{};

  bool get isConnected;

  Map<String, E2Box> get onlineBoxes => boxes;

  void sendCommand(E2Command command);

  Future<void> connect();

  Future<void> close();
}
