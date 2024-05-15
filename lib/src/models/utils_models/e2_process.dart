class E2Process {
  const E2Process({
    required this.pid,
    required this.gpuInstanceId,
    required this.computeInstanceId,
    required this.allocatedMem,
  });

  final int pid;
  final int gpuInstanceId;
  final int computeInstanceId;
  final double allocatedMem;

  Map<String, dynamic> toMap() {
    return {
      'PID': pid,
      'GPUINSTANCEID': gpuInstanceId,
      'COMPUTEINSTANCEID': computeInstanceId,
      'ALLOCATED_MEM': allocatedMem,
    };
  }

  factory E2Process.fromMap(Map<String, dynamic> map) {
    return E2Process(
      pid: map['PID'] as int,
      gpuInstanceId: map['GPUINSTANCEID'] as int,
      computeInstanceId: map['COMPUTEINSTANCEID'] as int,
      allocatedMem: map['ALLOCATED_MEM'] as double,
    );
  }

  static List<E2Process> fromList(List<dynamic> list) {
    final processes = <E2Process>[];
    for (final dynamic element in list) {
      processes.add(E2Process.fromMap(element as Map<String, dynamic>));
    }
    return processes;
  }

  static List<Map<String, dynamic>> toListMap(List<E2Process> list) {
    final processes = <Map<String, dynamic>>[];
    for (final E2Process element in list) {
      processes.add(element.toMap());
    }
    return processes;
  }
}
