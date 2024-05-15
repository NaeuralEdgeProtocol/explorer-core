class E2ActivePlugin {
  E2ActivePlugin({
    required this.streamId,
    required this.signature,
    required this.instanceId,
    required this.frequency,
    required this.initTimestamp,
    required this.execTimestamp,
    required this.lastConfigTimestamp,
    required this.firstErrorTime,
    required this.lastErrorTime,
    required this.outsideWorkingHours,
  });

  /// could be considered a pipelineId
  final String streamId;
  final String signature;
  final String instanceId;
  final double? frequency;
  final String? initTimestamp;
  final String? execTimestamp;
  final String lastConfigTimestamp;
  final String? firstErrorTime;
  final String? lastErrorTime;
  final bool outsideWorkingHours;

  Map<String, dynamic> toMap() {
    return {
      'STREAM_ID': streamId,
      'SIGNATURE': signature,
      'INSTANCE_ID': instanceId,
      'FREQUENCY': frequency,
      'INIT_TIMESTAMP': initTimestamp,
      'EXEC_TIMESTAMP': execTimestamp,
      'LAST_CONFIG_TIMESTAMP': lastConfigTimestamp,
      'FIRST_ERROR_TIME': firstErrorTime,
      'LAST_ERROR_TIME': lastErrorTime,
      'OUTSIDE_WORKING_HOURS': outsideWorkingHours,
    };
  }

  factory E2ActivePlugin.fromMap(Map<String, dynamic> map) {
    return E2ActivePlugin(
      streamId: map['STREAM_ID'] as String,
      signature: map['SIGNATURE'] as String,
      instanceId: map['INSTANCE_ID'] as String,
      frequency: map['FREQUENCY'] as double?,
      initTimestamp: map['INIT_TIMESTAMP'] as String?,
      execTimestamp: map['EXEC_TIMESTAMP'] as String?,
      lastConfigTimestamp: map['LAST_CONFIG_TIMESTAMP'] as String,
      firstErrorTime: map['FIRST_ERROR_TIME'] as String?,
      lastErrorTime: map['LAST_ERROR_TIME'] as String?,
      outsideWorkingHours: map['OUTSIDE_WORKING_HOURS'] as bool,
    );
  }

  static List<E2ActivePlugin> fromList(List<dynamic> list) {
    final elements = <E2ActivePlugin>[];
    for (final dynamic element in list) {
      elements.add(E2ActivePlugin.fromMap(element as Map<String, dynamic>));
    }
    return elements;
  }

  static List<Map<String, dynamic>> toListMap(List<E2ActivePlugin> list) {
    final elements = <Map<String, dynamic>>[];
    for (final E2ActivePlugin element in list) {
      elements.add(element.toMap());
    }
    return elements;
  }
}
