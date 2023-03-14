import 'package:flutter/services.dart';

class HinaFlutterPlugin {
  static MethodChannel get _channel =>
      ChannelManager.getInstance().methodChannel;

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

  static Future<String> trackTimerStart(String eventName) async {
    List<String> params = [eventName];
    return await _channel.invokeMethod('trackTimerStart', params);
  }

  static void trackTimerEnd(
      String eventName, Map<String, dynamic>? properties) {
    properties = properties == null ? {} : {...properties};
    List<dynamic> params = [eventName, properties];
    _channel.invokeMethod('trackTimerEnd', params);
  }

  static Future<Map<String, dynamic>?> getPresetProperties() async {
    return await _channel
        .invokeMapMethod<String, dynamic>("getPresetProperties");
  }

  static void registerCommonProperties(Map<String, dynamic> commonProperties) {
    if (commonProperties != null) {
      commonProperties = {...commonProperties};
    }
    List<dynamic> params = [commonProperties];
    _channel.invokeMethod('registerCommonProperties', params);
  }

  static void userSet(Map<String, dynamic> userProperties) {
    if (userProperties != null) {
      userProperties = {...userProperties};
    }
    List<dynamic> params = [userProperties];
    _channel.invokeMethod("userSet", params);
  }

  static void userSetOnce(Map<String, dynamic> userProperties) {
    if (userProperties != null) {
      userProperties = {...userProperties};
    }
    List<dynamic> params = [userProperties];
    _channel.invokeMethod("userSetOnce", params);
  }

  static void userAdd(Map<String, num> userProperties) {
    if (userProperties != null) {
      userProperties = {...userProperties};
    }
    List<dynamic> params = [userProperties];
    _channel.invokeMethod("userAdd", params);
  }

  static void userAppend(String key, List<String> values) {
    _channel.invokeMethod("userAppend", [key, values]);
  }

  static void userUnset(String key) {
    List<String> params = [key];
    _channel.invokeMethod("userUnset", params);
  }

  static void userDelete() {
    _channel.invokeMethod("userDelete");
  }

  static void setUserUId(String userId) {
    List<String> params = [userId];
    _channel.invokeMethod("setUserUId", params);
  }

  static void setPushUId(String pushTypeKey, String pushUId) {
    List<Map<String, String>> params = [
      {pushTypeKey: pushUId}
    ];
    _channel.invokeMethod("setPushUId", params);
  }

  static void setDeviceUId(String deviceUId) {
    List<String> params = [deviceUId];
    _channel.invokeMethod("setDeviceUId", params);
  }

  static Future<String?> getDeviceUId() async {
    return await _channel.invokeMethod<String>('getDeviceUId');
  }

  static void setFlushPendSize(int size) {
    List<int> params = [size];
    _channel.invokeMethod("setFlushPendSize", params);
  }

  static void setFlushInterval(int interval) {
    List<int> params = [interval];
    _channel.invokeMethod("setFlushInterval", params);
  }

  static void flush() {
    _channel.invokeMethod("flush");
  }

  static void clear() {
    _channel.invokeMethod("clear");
  }

  static void enableTrackScreenOrientation(bool enable) {
    List<bool> params = [enable];
    _channel.invokeMethod("enableTrackScreenOrientation", params);
  }

  static void enableTrackAppCrash() {
    _channel.invokeMethod("enableTrackAppCrash");
  }

  static void enableLog(bool enable) {
    List<bool> params = [enable];
    _channel.invokeMethod("enableLog", params);
  }

  static void disableSDK(bool enable) {
    List<bool> params = [enable];
    _channel.invokeMethod("disableSDK", params);
  }

  static Future<String?> getPlatformVersion() async {
    return await _channel.invokeMethod<String>('getPlatformVersion');
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
