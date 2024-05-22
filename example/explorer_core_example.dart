import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:explorer_core/explorer_core.dart';
import 'application/e2_client.dart';

const pipelinename = 'admin_pipeline';
const signatureId = 'UPDATE_MONITOR_01';
const instanceId = 'UPDATE_MONITOR_01_INST';
const targetId = 'gts-test2';

void main() {
  example();
}

example() async {
  var aixpKeypair = AixpKeyPair(isDebug: false);

  var env = DotEnv(includePlatformEnvironment: true)..load();

  ///Create KeyPair
  // aixpKeypair.createKeypair();

  ///Load KeyPair from Pem Private Key
  var file = File.fromUri(Uri.file('example/privatekey.pem'));
  var pem = file.readAsStringSync();
  aixpKeypair.loadKeypair(pem);

  final mqttServer = MqttServer(
    name: env.getOrElse('SERVER_NAME', () => MqttServer.defaultServer.name),
    host: env.getOrElse('HOST', () => MqttServer.defaultServer.host),
    username: env.getOrElse(
        'USERNAME', () => MqttServer.defaultServer.username ?? ''),
    password: env.getOrElse(
        'PASSWORD', () => MqttServer.defaultServer.password ?? ''),
    port: int.parse(
      env.getOrElse('PORT', () => MqttServer.defaultServer.port.toString()),
    ),
  );

  ///Connect our MQTT Server
  E2Client.changeConnectionData(mqttServer);
  final E2Client client = E2Client();
  await client.connect();

  ///HeartBeat Listner
  client.notifiers.heartbeats.addListener((data) {
    var payloadpath = data.payloadPath;
    print("HeartBeat $payloadpath");

    ///Handle Commands logs
    ///In response to full HeartBeat command Request
    final bool isV2 = data.heartbeatVersion == 'v2';
    if (isV2 &&
        data.encodedData!['DEVICE_LOG'] is List<dynamic> &&
        payloadpath[0] == targetId) {
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(data.encodedData!['DEVICE_LOG']);
      print(prettyprint);
    }
  });

  ///Notification Listner
  client.notifiers.notifications.addListener((data) {
    print("Payload ${data.payloadPath}");
  });

  ///Payload Listner
  client.notifiers.payloads.addListener((data) {
    print("Payload ${data.payloadPath}");
    var payloadpath = data.payloadPath;

    /// Handle Config View
    /// In Response to GET_CONFIG Command View
    if (payloadpath[0] == targetId &&
        payloadpath[1] == pipelinename &&
        payloadpath[2] == signatureId &&
        payloadpath[3] == instanceId) {
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(data.content['CONFIG_STARTUP']);
      print(prettyprint);
    }
  });

  var getConfigCommand = ActionCommands.updatePipelineInstance(
    targetId: targetId,
    initiatorId: aixpKeypair.initiatorId,
    payload: E2InstanceConfig(
      instanceConfig: {
        "INSTANCE_COMMAND": {"COMMAND": "GET_CONFIG"}
      },
      instanceId: instanceId,
      name: pipelinename,
      signature: signatureId,
    ),
    signerCallback: (p0) => aixpKeypair.signMessage(p0),
  );
  var fullHeartBeatCommand = ActionCommands.fullHeartbeat(
    targetId: targetId,
    signerCallback: (p0) => aixpKeypair.signMessage(p0),
  );

  ///Send Command to server
  client.session.sendCommand(getConfigCommand);

  ///Send Command to server
  client.session.sendCommand(fullHeartBeatCommand);
}
