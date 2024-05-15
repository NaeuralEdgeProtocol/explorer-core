class E2LoopTiming {
  final num mainLoopAvgTime;
  final num commLoopAvgTime;

  E2LoopTiming({
    required this.mainLoopAvgTime,
    required this.commLoopAvgTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'main_loop_avg_time': mainLoopAvgTime,
      'comm_loop_avg_time': commLoopAvgTime,
    };
  }

  factory E2LoopTiming.fromMap(Map<String, dynamic> map) {
    return E2LoopTiming(
      mainLoopAvgTime: map['main_loop_avg_time'] as num,
      commLoopAvgTime: map['comm_loop_avg_time'] as num,
    );
  }
}
