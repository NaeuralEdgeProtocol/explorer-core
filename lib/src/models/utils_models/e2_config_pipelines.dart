import 'package:explorer_core/src/models/utils_models/pipelines/e2_meta_stream.dart';
import 'package:explorer_core/src/models/utils_models/pipelines/e2_pipeline.dart';
import 'package:explorer_core/src/models/utils_models/pipelines/e2_single_crop_meta_stream.dart';
import 'package:explorer_core/src/models/utils_models/pipelines/e2_video_stream.dart';

/// This class is the equivalent of config streams
class E2ConfigPipelines {
  E2ConfigPipelines({
    required this.videoStreams,
    required this.metaStreams,
    required this.singleCropMetaStreams,
    required this.allPipelines,
  });

  final List<E2VideoStream> videoStreams;
  final List<E2MetaStream> metaStreams;
  final List<E2SingleCropMetaStream> singleCropMetaStreams;
  final List<E2Pipeline> allPipelines;

  static const String _videoStreamType = 'VideoStream';
  static const String _metaStreamType = 'MetaStream';
  static const String _singleCropMetaStreamType = 'SingleCropMetaStream';
  static const String _typeKey = 'TYPE';

  factory E2ConfigPipelines.fromList(List<dynamic>? list) {
    final videoStreams = <E2VideoStream>[];
    final metaStreams = <E2MetaStream>[];
    final singleCropMetaStreams = <E2SingleCropMetaStream>[];
    final allPipelines = <E2Pipeline>[];

    if (list != null) {
      for (Map<String, dynamic> element in list) {
        final type = element[_typeKey];
        if (type == _videoStreamType) {
          videoStreams.add(E2VideoStream.fromMap(element));
        } else if (type == _metaStreamType) {
          metaStreams.add(E2MetaStream.fromMap(element));
        } else if (type == _singleCropMetaStreamType) {
          singleCropMetaStreams.add(E2SingleCropMetaStream.fromMap(element));
        }
        allPipelines.add(E2Pipeline.fromMap(element));
      }
    }

    return E2ConfigPipelines(
      videoStreams: videoStreams,
      metaStreams: metaStreams,
      singleCropMetaStreams: singleCropMetaStreams,
      allPipelines: allPipelines,
    );
  }

  List<Map<String, dynamic>> toListMap() {
    final combinedList = <Map<String, dynamic>>[];
    for (final stream in videoStreams) {
      combinedList.add(stream.toMap());
    }

    for (final stream in metaStreams) {
      combinedList.add(stream.toMap());
    }

    for (final stream in singleCropMetaStreams) {
      combinedList.add(stream.toMap());
    }

    return combinedList;
  }
}
