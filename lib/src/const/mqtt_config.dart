import 'package:mqtt5_client/mqtt5_client.dart';

class MqttConfig {
  static const String configChannelTopic = 'lummetry/{}/config';

  static const String controlChannelTopic = 'lummetry/ctrl';

  static const String notificationChannelTopic = 'lummetry/notif';

  static const String payloadsChannelTopic = 'lummetry/payloads';

  static const MqttQos qos = MqttQos.atMostOnce;

  static String host = 'mq.dev.hyperfy.tech';

  static int port = 1883;

  static String user = 'edmon';

  static String password = 'cavi-edmon';

  static void changeConfig({
    String? host,
    int? port,
    String? user,
    String? password,
  }) {
    MqttConfig.host = host ?? MqttConfig.host;
    MqttConfig.port = port ?? MqttConfig.port;
    MqttConfig.user = user ?? MqttConfig.user;
    MqttConfig.password = password ?? MqttConfig.password;
  }
}
