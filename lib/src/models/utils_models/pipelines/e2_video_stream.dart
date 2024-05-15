import 'package:explorer_core/src/models/utils_models/e2_plugin.dart';

import 'e2_pipeline.dart';

class E2VideoStream extends E2Pipeline {
  E2VideoStream({
    required this.capResolution,
    required this.defaultPlugin,
    required this.liveFeed,
    required this.reconnectable,
    required this.url,
    required super.initiatorId,
    required super.name,
    required super.plugins,
    required super.type,
    required super.sessionId,
  });

  final int capResolution;
  final bool? defaultPlugin;
  final bool? liveFeed;

  /// Can be the following values: null, 'YES', true
  final dynamic reconnectable;

  final dynamic url;

  factory E2VideoStream.fromMap(Map<String, dynamic> map) {
    return E2VideoStream(
      capResolution: map['CAP_RESOLUTION'] as int,
      defaultPlugin: map['DEFAULT_PLUGIN'] as bool?,
      liveFeed: map['LIVE_FEED'] as bool?,
      reconnectable: map['RECONNECTABLE'],
      url: map['URL'] as dynamic,
      initiatorId: map['INITIATOR_ID'] as String?,
      name: map['NAME'] as String,
      plugins: E2Plugin.fromList(map['PLUGINS'] as List),
      type: map['TYPE'] as String,
      sessionId: map['SESSION_ID'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'CAP_RESOLUTION': capResolution,
      'DEFAULT_PLUGIN': defaultPlugin,
      'LIVE_FEED': liveFeed,
      'RECONNECTABLE': reconnectable,
      'URL': url,
    }..addAll(super.toMap());
  }
}
