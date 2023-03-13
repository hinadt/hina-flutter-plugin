import 'package:flutter/services.dart';

class HinaFlutterPlugin {
  static MethodChannel get _channel => ChannelManager.getInstance().methodChannel;

  static Future<void> init(
      {required String? serverUrl,
        int flushInterval = 15000,
        int flushBulkSize = 100,
        bool enableLog = false}) async {
    Map<String, dynamic> initConfig = {
      "serverUrl": serverUrl,
      "enableLog": enableLog,
      "flushInterval": flushInterval,
      "flushBulkSize": flushBulkSize,
    };
    await _channel.invokeMethod("init", [initConfig]);
  }

  static void track(String eventName, Map<String, dynamic>? properties) {
    properties = properties == null ? {} : {...properties};
    List<dynamic> params = [eventName, properties];
    _channel.invokeMethod('track', params);
  }

  static Future<String?> getPlatformVersion() {
    return _channel.invokeMethod<String>('getPlatformVersion');
  }
}

/// Flutter MethodChannel Manager
class ChannelManager {
  static ChannelManager _instance = ChannelManager._();

  factory ChannelManager.getInstance() => _instance;

  final MethodChannel _channel = const MethodChannel('hina_flutter_plugin');

  ChannelManager._();

  MethodChannel get methodChannel => _channel;
}
