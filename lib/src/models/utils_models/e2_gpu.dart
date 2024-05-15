import 'e2_process.dart';

class E2Gpu {
  E2Gpu({
    required this.name,
    required this.totalMem,
    required this.processes,
    required this.usedByProcess,
    required this.allocatedMem,
    required this.freeMem,
    required this.memUnit,
    required this.gpuUsed,
    required this.gpuTemp,
    required this.gpuTempMax,
  });

  final String name;
  final double totalMem;
  final List<E2Process> processes;
  final bool usedByProcess;
  final double allocatedMem;
  final double freeMem;
  final String memUnit;
  final int gpuUsed;
  final int gpuTemp;
  final int gpuTempMax;

  Map<String, dynamic> toMap() {
    return {
      'NAME': name,
      'TOTAL_MEM': totalMem,
      'PROCESSES': E2Process.toListMap(processes),
      'USED_BY_PROCESS': usedByProcess,
      'ALLOCATED_MEM': allocatedMem,
      'FREE_MEM': freeMem,
      'MEM_UNIT': memUnit,
      'GPU_USED': gpuUsed,
      'GPU_TEMP': gpuTemp,
      'GPU_TEMP_MAX': gpuTempMax,
    };
  }

  factory E2Gpu.fromMap(Map<String, dynamic> map) {
    return E2Gpu(
      name: map['NAME'] as String,
      totalMem: map['TOTAL_MEM'] as double,
      processes: E2Process.fromList(map['PROCESSES'] as List),
      usedByProcess: map['USED_BY_PROCESS'] as bool,
      allocatedMem: map['ALLOCATED_MEM'] as double,
      freeMem: map['FREE_MEM'] as double,
      memUnit: map['MEM_UNIT'] as String,
      gpuUsed: map['GPU_USED'] as int,
      gpuTemp: map['GPU_TEMP'] as int,
      gpuTempMax: map['GPU_TEMP_MAX'] as int,
    );
  }

  static List<E2Gpu> fromList(dynamic jsonList) {
    final elements = <E2Gpu>[];
    try {
      final list = jsonList as List;
      for (final dynamic element in list) {
        elements.add(E2Gpu.fromMap(element as Map<String, dynamic>));
      }
    } catch (_) {
      // if (kDebugMode) {
      //   print('Cannot decompile GPU');
      //   if (jsonList is String) {
      //     elements.add(
      //       E2Gpu(
      //         name: jsonList,
      //         totalMem: 0,
      //         processes: [],
      //         usedByProcess: false,
      //         allocatedMem: 0,
      //         freeMem: 0,
      //         memUnit: 'N/A',
      //         gpuUsed: 0,
      //         gpuTemp: 0,
      //         gpuTempMax: 0,
      //       ),
      //     );
      //   }
      // }
    }
    return elements;
  }

  static List<Map<String, dynamic>> toListMap(List<E2Gpu> list) {
    final elements = <Map<String, dynamic>>[];
    for (final E2Gpu element in list) {
      elements.add(element.toMap());
    }
    return elements;
  }
}
