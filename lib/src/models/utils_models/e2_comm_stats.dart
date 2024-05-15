import 'package:explorer_core/src/models/utils_models/stats/e2_comm_stat.dart';

class E2CommStats {
  final E2CommStat commandControl;
  final E2CommStat defaultControl;
  final E2CommStat heartbeats;
  final E2CommStat notifications;

  E2CommStats({
    required this.commandControl,
    required this.defaultControl,
    required this.heartbeats,
    required this.notifications,
  });

  Map<String, dynamic> toMap() {
    return {
      'COMMANDCONTROL': commandControl.toMap(),
      'DEFAULT': defaultControl.toMap(),
      'HEARTBEATS': heartbeats.toMap(),
      'NOTIFICATIONS': notifications.toMap(),
    };
  }

  factory E2CommStats.fromMap(Map<String, dynamic> map) {
    return E2CommStats(
      commandControl: E2CommStat.fromMap(map['COMMANDCONTROL']),
      defaultControl: E2CommStat.fromMap(map['DEFAULT']),
      heartbeats: E2CommStat.fromMap(map['HEARTBEATS']),
      notifications: E2CommStat.fromMap(map['NOTIFICATIONS']),
    );
  }
}
