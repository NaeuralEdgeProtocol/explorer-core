import 'format_decoder.dart';

/// Cavi2 encoder and decoders.
/// Port of https://github.com/AiXpand/PyE2/blob/main/PyE2/io_formatter/default/aixp1.py
/// and https://github.com/AiXpand/tsclient/blob/main/src/decoders/cavi2.decoder.ts

class Cavi2MessageEncoderDecoder implements MqttMessageEncoderDecoder {
  final mandatoryKeys = ['EE_SIGN', 'EE_SENDER', 'EE_HASH', 'EE_PAYLOAD_PATH'];

  @override
  Map<String, dynamic> decode(Map<String, dynamic> encoded) {
    try {
      Map<String, dynamic> transformed = {
        'EE_FORMATTER': null,
      };

      // handle mandatory keys
      for (final key in mandatoryKeys) {
        if (!encoded.containsKey(key)) {
          throw FormatException(
              'EE_FORMATTER is invalid for the message with path: ${encoded['EE_PAYLOAD_PATH']}');
        } else {
          transformed[key] = encoded[key];
        }
      }

      ///  handle event type
      String? eventType = encoded['type'];
      String? eEventType = encoded['type'];

      // if type is other than 'notification' or 'heartbeat' then it is a payload
      if (eventType != 'notification' && eventType != 'heartbeat') {
        eEventType = 'payload';
      }

      transformed['EE_EVENT_TYPE'] = eEventType?.toUpperCase();

      final encodedData = encoded['data'];
      final encodedMetadata = encoded['metadata'];

      // Process 'sender' zone
      transformed['EE_ID'] = encoded['sender']?['hostId'];

      // Process 'time' zone
      transformed['EE_TIMESTAMP'] = encoded['time']?['hostTime'];

      // Extract metadata values
      transformed['EE_TOTAL_MESSAGES'] = encodedMetadata?['sbTotalMessages'];
      transformed['EE_MESSAGE_ID'] = encodedMetadata?['sbCurrentMessage'];

      // Process additional data if not a 'notification' or 'heartbeat' event
      if (eEventType == 'payload') {
        transformed['SIGNATURE'] = eventType?.toUpperCase();

        // Rename and add capture metadata
        final decodedCaptureMetadata = Map<String, dynamic>.from({});
        encodedMetadata?['captureMetadata']?.forEach((k, v) {
          decodedCaptureMetadata['_C_$k'] = v;
        });

        // Rename and add plugin metadata
        final decodedPluginMetadata = Map<String, dynamic>.from({});
        encodedMetadata?['pluginMetadata']?.forEach((k, v) {
          decodedPluginMetadata['_P_$k'] = v;
        });

        // Process data values
        transformed['STREAM'] = encodedData?['identifiers']?['streamId'];
        transformed['INSTANCE_ID'] = encodedData?['identifiers']?['instanceId'];
        transformed['ID'] = encodedData?['identifiers']?['payloadId'];
        transformed['ID_TAGS'] = encodedData?['identifiers']?['idTags'];

        transformed['INITIATOR_ID'] =
            encodedData?['identifiers']?['initiatorId'];
        transformed['SESSION_ID'] = encodedData?['identifiers']?['sessionId'];

        // Process data 'value' and 'specificValue'
        encodedData?['value']?.forEach((k, v) {
          transformed[k.toUpperCase()] = v;
        });

        encodedData?['specificValue'].forEach((k, v) {
          transformed[k.toUpperCase()] = v;
        });

        // process time data : // TODO: handle time when null
        transformed['TIMESTAMP_EXECUTION'] = encodedData?['time'];

        if (encodedData['img'] != null) {
          if (encodedData['img'].runtimeType == List) {
            (encodedData['img'] as List).asMap().forEach(
              (key, value) {
                transformed['IMG'][key] = value['id'];
                // transformed['IMG_HEIGHT'][key] = value['height'];
                // transformed['IMG_WIDTH'][key] = value['width'];
              },
            );

            print('image is list');
          } else {
            transformed['IMG'] = encodedData['img']['id'];
            // transformed['IMG_HEIGHT'] = encodedData['img']['height'];
            // transformed['IMG_WIDTH'] = encodedData['img']['width'];

            print('image is string');
          }
        }

        // Merge transformed with capture and plugin metadata
        transformed = {
          ...transformed,
          ...decodedCaptureMetadata,
          ...decodedPluginMetadata
        };
      }

      // Process remaining metadata
      encodedMetadata?.forEach((k, v) {
        transformed[k.toUpperCase()] = v;
      });

      return transformed;
    } catch (e, s) {
      print("Could not decode cavi2 ${encoded['type']}: $e $s");
      return {};
    }
  }

  /// decoded must be in raw format
  @override
  Map<String, dynamic> encoder(Map<String, dynamic> decoded) {
    var eventType = decoded.remove('EE_EVENT_TYPE');

    // Below fields are not required as they will be decorated post-formatting anyway
    decoded.remove('EE_MESSAGE_ID');
    decoded.remove('EE_MESSAGE_SEQ');
    decoded.remove('EE_TOTAL_MESSAGES');

    decoded.remove('EE_TIMESTAMP');
    decoded.remove('EE_ID');
    decoded.remove('STREAM_NAME');
    decoded.remove('SIGNATURE');
    decoded.remove('INSTANCE_ID');

    decoded.remove('EE_TIMEZONE');
    decoded.remove('EE_VERSION');
    decoded.remove('EE_TZ');

    decoded.remove('INITIATOR_ID');
    decoded.remove('SESSION_ID');
    // End non-managed fields

    var lvl0Dct = {
      "DATA": {},
    };

    var lvl1Dct = lvl0Dct['DATA'];

    if (eventType == 'PAYLOAD') {
      // Add payload context
      decoded.remove('STREAM');
      decoded.remove('PIPELINE');

      // Plugin meta
      if (true) {
        lvl1Dct?['PLUGIN_META'] = {};
        var pluginMetaKeys =
            decoded.keys.where((k) => k.startsWith('_P_')).toList();
        for (var k in pluginMetaKeys) {
          lvl1Dct?['PLUGIN_META'][k] = decoded.remove(k);
        }
      }

      // Pipeline meta
      if (true) {
        lvl1Dct?['PIPELINE_META'] = {};
        var pipelineMetaKeys =
            decoded.keys.where((k) => k.startsWith('_C_')).toList();
        for (var k in pipelineMetaKeys) {
          lvl1Dct?['PIPELINE_META'][k] = decoded.remove(k);
        }
      }
    }

    lvl1Dct?.addAll(decoded);

    return lvl0Dct;
  }
}
