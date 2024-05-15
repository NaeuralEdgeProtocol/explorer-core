import 'package:explorer_core/src/commands/e2_commands.dart';
import 'package:explorer_core/src/models/e2_box.dart';
import 'package:explorer_core/src/models/mqtt_server.dart';

abstract class GenericSession {
  GenericSession({
    required this.server,
    required this.onHeartbeat,
    required this.onNotification,
    required this.onPayload,
  });

  final MqttServer server;
  final void Function(Map<String, dynamic>) onHeartbeat;
  final void Function(Map<String, dynamic>) onNotification;
  final void Function(Map<String, dynamic>) onPayload;

  final Map<String, E2Box> boxes = <String, E2Box>{};

  bool get isConnected;

  Map<String, E2Box> get onlineBoxes => boxes;

  void sendCommand(E2Command command);

  Future<void> connect();

  Future<void> close();
}
