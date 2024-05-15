import 'package:explorer_core/src/models/utils_models/stats/e2_dct_stat.dart';

class E2DctStats {
  E2DctStats({required this.stats});

  Map<String, E2DctStat> stats;

  E2DctStat? getStatById(String id) {
    return stats[id];
  }

  factory E2DctStats.fromMap(Map<String, dynamic> map) {
    final stats = <String, E2DctStat>{};
    map.forEach((key, value) {
      final mappedValue = E2DctStat.fromMap(value as Map<String, dynamic>);
      stats[key] = mappedValue;
    });
    return E2DctStats(
      stats: stats,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> returnedMap = {};
    stats.forEach((key, value) {
      returnedMap[key] = value.toMap();
    });
    return returnedMap;
  }
}
