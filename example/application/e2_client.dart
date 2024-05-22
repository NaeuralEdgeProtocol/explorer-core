import 'package:explorer_core/explorer_core.dart';
import 'package:explorer_core/src/default/mqtt_session.dart';
import 'package:explorer_core/src/models/messages/e2_heartbeat.dart';
import 'package:explorer_core/src/models/messages/e2_notification.dart';
import 'package:explorer_core/src/models/mqtt_server.dart';
import 'package:explorer_core/src/models/utils_models/e2_heartbeat.dart';
import 'package:explorer_core/src/notifier/notifier.dart';

class E2Notifiers {
  final EventsNotifier<E2Heartbeat> heartbeats = EventsNotifier();
  final EventsNotifier<E2Payload> payloads = EventsNotifier<E2Payload>();
  final EventsNotifier<E2Notification> notifications = EventsNotifier();
  final EventsNotifier all = EventsNotifier();
  final EventsNotifier connection = EventsNotifier();
}

class E2Client {
  static E2Client _singleton = E2Client._internal();

  factory E2Client() {
    return _singleton;
  }

  /// Gives a new instance for our e2 client to remove all data
  static void clearClientData() {
    _singleton.disconnect();
    _singleton = E2Client._internal();
  }

  static void changeConnectionData(MqttServer connectionServer) {
    if (_singleton.isConnected) {
      _singleton.disconnect();
    }
    _singleton = E2Client._internal(server: connectionServer);
  }

  late MqttServer _server;

  MqttServer get server => _server;

  String? selectedBoxName;
  late MqttSession session;

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  E2Notifiers notifiers = E2Notifiers();

  E2Client._internal({MqttServer? server}) {
    _server = server ?? MqttServer.defaultServer;
    session = MqttSession(
      server: _server,
      onHeartbeat: _onHeartbeat,
      onNotification: _onNotification,
      onPayload: _onPayload,
    );
  }

  Future<void> connect() async {
    await session.connect();
    _isConnected = session.isConnected;
    notifiers.connection.emit(true);
  }

  void disconnect() {
    session.close();
    _isConnected = false;
    notifiers.connection.emit(false);
  }

  void _onHeartbeat(E2Heartbeat message) {
    notifiers.heartbeats.emit(message);
    notifiers.all.emit(message);
  }

  void _onNotification(E2Notification message) {
    notifiers.notifications.emit(message);
    notifiers.all.emit(message.messageBody);
  }

  void _onPayload(E2Payload message) {
    try {
      notifiers.payloads.emit(message);
      notifiers.all.emit(message);
    } catch (_) {}
  }
}
