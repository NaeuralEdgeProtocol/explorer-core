import '../e2_plugin.dart';

class E2Pipeline {
  E2Pipeline({
    required this.initiatorId,
    required this.name,
    required this.plugins,
    required this.type,
    required this.sessionId,
  });

  final String? initiatorId;
  final String name;
  final List<E2Plugin> plugins;
  final String type;
  final String? sessionId;

  factory E2Pipeline.fromMap(Map<String, dynamic> map) {
    return E2Pipeline(
      initiatorId: map['INITIATOR_ID'] as String?,
      name: map['NAME'] as String,
      plugins: E2Plugin.fromList(map['PLUGINS'] as List),
      type: map['TYPE'] as String,
      sessionId: map['SESSION_ID'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'INITIATOR_ID': initiatorId,
      'NAME': name,
      'PLUGINS': E2Plugin.toListMap(plugins),
      'TYPE': type,
      'SESSION_ID': sessionId,
    };
  }
}
