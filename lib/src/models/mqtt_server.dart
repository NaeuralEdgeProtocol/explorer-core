import 'package:explorer_core/src/const/mqtt_config.dart';

/// Used to represent user added mqtt servers
class MqttServer {
  MqttServer({
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    this.isSecured = false,
  });

  /// The display name for the server. This name can be anything, and we shouldn't have name duplicates. Its used to represent
  /// a more friendly name for the user.
  final String name;

  /// The mqtt host that we want to connect to.
  final String host;

  /// The mqtt port that we want to connect to.
  final int port;

  /// Mqtt username
  final String? username;

  /// Mqtt Secured TLS connection or not
  final bool isSecured;

  /// Mqtt password
  /// ToDO: The password should be stored differently? Encrypted?
  final String? password;

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "host": host,
      "port": port,
      "username": username,
      "password": password,
      "isSecured": isSecured,
    };
  }

  /// Default object for server. This should not be used like this in the future
  static final MqttServer defaultServer = MqttServer(
    name: 'Default server',
    host: MqttConfig.host,
    port: MqttConfig.port,
    username: MqttConfig.user,
    password: MqttConfig.password,
  );
}
