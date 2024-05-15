import 'dart:convert';

typedef SignerCallback = Map<String, dynamic> Function(Map<String, dynamic>);

enum CommandAction {
  stop,
  restart,
  archiveConfig,
  archiveConfigAll,
  updatePipelineInstance,
  updateConfig,
  reloadConfigFromDisk,
  simpleHeartbeat,
  timersOnlyHeartbeat,
  fullHeartbeat,
}

String _actionToString(CommandAction action) {
  switch (action) {
    case CommandAction.stop:
      return 'STOP';
    case CommandAction.restart:
      return 'RESTART';
    case CommandAction.archiveConfig:
      return 'ARCHIVE_CONFIG';
    case CommandAction.archiveConfigAll:
      return 'ARCHIVE_CONFIG_ALL';
    case CommandAction.updatePipelineInstance:
      return 'UPDATE_PIPELINE_INSTANCE';
    case CommandAction.updateConfig:
      return 'UPDATE_CONFIG';
    case CommandAction.reloadConfigFromDisk:
      return 'RELOAD_CONFIG_FROM_DISK';
    case CommandAction.simpleHeartbeat:
      return 'SIMPLE_HEARTBEAT';
    case CommandAction.timersOnlyHeartbeat:
      return 'TIMERS_ONLY_HEARTBEAT';
    case CommandAction.fullHeartbeat:
      return 'FULL_HEARTBEAT';
  }
}

/// ToDO: Ask about what E2Pipeline is exactly. What is type?
/*
class E2PipelineConfig {
  String name;
  String type;
  String url;
}
*/

class E2InstanceConfig {
  E2InstanceConfig({
    required this.name,
    required this.signature,
    required this.instanceId,
    required this.instanceConfig,
  });

  final String name;
  final String signature;
  final String instanceId;
  final Map<String, dynamic> instanceConfig;

  Map<String, dynamic> toMap() {
    return {
      'NAME': name,
      'SIGNATURE': signature,
      'INSTANCE_ID': instanceId,
      'INSTANCE_CONFIG': instanceConfig,
    };
  }

  factory E2InstanceConfig.fromMap(Map<String, dynamic> map) {
    return E2InstanceConfig(
      name: map['NAME'] as String,
      signature: map['SIGNATURE'] as String,
      instanceId: map['INSTANCE_ID'] as String,
      instanceConfig: map['INSTANCE_CONFIG'] as Map<String, dynamic>,
    );
  }
}

class E2Command {
  /// ToDO: in the future we will have signature as well
  E2Command._({
    required this.targetId,
    required this.action,
    this.payload,
    this.initiatorId,
    this.sessionId,
    required this.signerCallback,
  });

  final String targetId;
  final CommandAction action;
  final dynamic payload;
  final String? initiatorId;
  final String? sessionId;
  final SignerCallback signerCallback;

  Map<String, dynamic> toMap() {
    return {
      'EE_ID': targetId,
      'ACTION': _actionToString(action),
      'PAYLOAD': payload,
      'INITIATOR_ID': initiatorId,
      'SESSION_ID': sessionId,
      'TIME': DateTime.now().millisecondsSinceEpoch,
    }..removeWhere((key, value) => value == null);
  }

  Map<String, dynamic> signedMap() {
    return signerCallback(toMap());
  }

  String toJson() {
    return jsonEncode(signedMap());
  }

  /// ToDO: Do we need this?
  // factory E2Command.fromMap(Map<String, dynamic> map) {
  //   return E2Command._(
  //     targetId: map['EE_ID'] as String,
  //     action: map['ACTION'] as CommandAction,
  //     payload: map['PAYLOAD'] as dynamic,
  //     initiatorId: map['INITIATOR_ID'] as String,
  //     sessionId: map['SESSION_ID'] as String,
  //   );
  // }
}

extension ActionCommands on E2Command {
  /// Initiates a shutdown operation on the target box.
  static E2Command stop({
    required String targetId,
    String? initiatorId,
    String? sessionId,
    required SignerCallback signerCallback,
  }) {
    return E2Command._(
      targetId: targetId,
      action: CommandAction.stop,
      initiatorId: initiatorId,
      sessionId: sessionId,
      signerCallback: signerCallback,
    );
  }

  /// Initiates a restart operation on the target box.
  static E2Command restart({
    required String targetId,
    String? initiatorId,
    String? sessionId,
    required SignerCallback signerCallback,
  }) {
    return E2Command._(
      targetId: targetId,
      action: CommandAction.restart,
      initiatorId: initiatorId,
      sessionId: sessionId,
      signerCallback: signerCallback,
    );
  }

  /// This can be considered a “safe” DELETE operation. The pipeline is removed, but its config is archived on disk.
  static E2Command archiveConfig({
    required String targetId,
    required String pipelineName,
    String? initiatorId,
    String? sessionId,
    required SignerCallback signerCallback,
  }) {
    return E2Command._(
      targetId: targetId,
      action: CommandAction.archiveConfig,
      payload: pipelineName,
      initiatorId: initiatorId,
      sessionId: sessionId,
      signerCallback: signerCallback,
    );
  }

  /// Archives and removes all active pipelines on the box.
  static E2Command archiveConfigAll({
    required String targetId,
    String? initiatorId,
    String? sessionId,
    required SignerCallback signerCallback,
  }) {
    return E2Command._(
      targetId: targetId,
      action: CommandAction.archiveConfigAll,
      initiatorId: initiatorId,
      sessionId: sessionId,
      signerCallback: signerCallback,
    );
  }

  /// Modifies a single instance.
  static E2Command updatePipelineInstance({
    required String targetId,
    required E2InstanceConfig payload,
    String? initiatorId,
    String? sessionId,
    required SignerCallback signerCallback,
  }) {
    return E2Command._(
      targetId: targetId,
      action: CommandAction.updatePipelineInstance,
      payload: payload.toMap(),
      initiatorId: initiatorId,
      sessionId: sessionId,
      signerCallback: signerCallback,
    );
  }

  /// Updates or launches a pipeline. This will modify all plugins.
  static E2Command updateConfig({
    required String targetId,
    required Map<String, dynamic> payload,
    String? initiatorId,
    String? sessionId,
    required SignerCallback signerCallback,
  }) {
    return E2Command._(
      targetId: targetId,
      action: CommandAction.updateConfig,
      payload: payload,
      initiatorId: initiatorId,
      sessionId: sessionId,
      signerCallback: signerCallback,
    );
  }

  /// Reloads all configurations from disk.
  static E2Command reloadConfigFromDisk({
    required String targetId,
    String? initiatorId,
    String? sessionId,
    required SignerCallback signerCallback,
  }) {
    return E2Command._(
      targetId: targetId,
      action: CommandAction.reloadConfigFromDisk,
      initiatorId: initiatorId,
      sessionId: sessionId,
      signerCallback: signerCallback,
    );
  }

  /// Requests a default heartbeat from the box. This heartbeat will be served shortly on the lummetry/ctrl (heartbeats) topic.
  static E2Command simpleHeartbeat({
    required String targetId,
    String? initiatorId,
    String? sessionId,
    required SignerCallback signerCallback,
  }) {
    return E2Command._(
      targetId: targetId,
      action: CommandAction.simpleHeartbeat,
      initiatorId: initiatorId,
      sessionId: sessionId,
      signerCallback: signerCallback,
    );
  }

  /// Requests a timers heartbeat.
  static E2Command timersOnlyHeartbeat({
    required String targetId,
    String? initiatorId,
    String? sessionId,
    required SignerCallback signerCallback,
  }) {
    return E2Command._(
      targetId: targetId,
      action: CommandAction.timersOnlyHeartbeat,
      initiatorId: initiatorId,
      sessionId: sessionId,
      signerCallback: signerCallback,
    );
  }

  /// Requests a full heartbeat (default heartbeat with timer).
  static E2Command fullHeartbeat({
    required String targetId,
    String? initiatorId,
    String? sessionId,
    required SignerCallback signerCallback,
  }) {
    return E2Command._(
      targetId: targetId,
      action: CommandAction.fullHeartbeat,
      initiatorId: initiatorId,
      sessionId: sessionId,
      signerCallback: signerCallback,
    );
  }
}
