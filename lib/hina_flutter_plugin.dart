import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum HANetworkType {
  TYPE_NONE,
  TYPE_2G,
  TYPE_3G,
  TYPE_4G,
  TYPE_WIFI,
  TYPE_5G,
  TYPE_ALL
}

enum HAAutoTrackType {
  TYPE_NONE,
  APP_START,
  APP_END,
  APP_CLICK,
  APP_VIEW_SCREEN
}

class HinaFlutterPlugin {
  static MethodChannel get _channel =>
      ChannelManager.getInstance().methodChannel;

  static Future<void> initForMobile(
      {required String? serverUrl,
      int flushInterval = 15000,
      int flushPendSize = 100,
      bool enableLog = false,
      bool enableJSBridge = false,
      int maxCacheSizeForAndroid = 32 * 1024 * 1024,
      int maxCacheSizeForIOS = 10000,
      Set<HAAutoTrackType>? autoTrackTypeList,
      Set<HANetworkType>? networkTypeList}) async {
    Map<String, dynamic> initConfig = {
      "serverUrl": serverUrl,
      "flushInterval": flushInterval,
      "flushPendSize": flushPendSize,
      "enableLog": enableLog,
      "enableJSBridge": enableJSBridge,
      "maxCacheSizeForAndroid": maxCacheSizeForAndroid,
      "maxCacheSizeForIOS": maxCacheSizeForIOS
    };
    int autoTrackTypePolicy = getAutoTrackTypes(autoTrackTypeList);
    if (autoTrackTypePolicy != -1) {
      initConfig["autoTrackTypePolicy"] = autoTrackTypePolicy;
    }
    int networkTypePolicy = getNetworkTypes(networkTypeList);
    if (networkTypePolicy != -1) {
      initConfig["networkTypePolicy"] = networkTypePolicy;
    }
    List<dynamic> params = [initConfig];
    await _channel.invokeMethod("init", params);
  }

  static Future<dynamic> callMethodForWeb(String method, [ List<dynamic>? arguments ]) {
    return _channel.invokeMethod(method, arguments);
  }

  static void track(String eventName, [ Map<String, dynamic>? properties ]) {
    properties = properties == null ? {} : {...properties};
    List<dynamic> params = [eventName, properties];
    _channel.invokeMethod('track', params);
  }

  static Future<String> trackTimerStart(String eventName) async {
    List<String> params = [eventName];
    return await _channel.invokeMethod('trackTimerStart', params);
  }

  static void trackTimerEnd(
      String eventName, [ Map<String, dynamic>? properties ]) {
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
    List<dynamic> params = [key, values];
    _channel.invokeMethod("userAppend", params);
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

  static void cleanUserUId() {
    _channel.invokeMethod("cleanUserUId");
  }

  static void setPushUId(String pushTypeKey, String pushUId) {
    List<String> params = [pushTypeKey, pushUId];
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

  static void setFlushNetworkPolicy(Set<HANetworkType>? networkTypeList) {
    int networkTypePolicy = getNetworkTypes(networkTypeList);
    if (networkTypePolicy != -1) {
      List<int> params = [networkTypePolicy];
      _channel.invokeMethod("setFlushNetworkPolicy", params);
    }
  }

  static void flush() {
    _channel.invokeMethod("flush");
  }

  static void clear() {
    _channel.invokeMethod("clear");
  }

  static Future<String?> getPlatformVersion() async {
    return await _channel.invokeMethod<String>('getPlatformVersion');
  }

  static int getAutoTrackTypes(Set<HAAutoTrackType>? autoTrackTypeList) {
    if (autoTrackTypeList != null && autoTrackTypeList.isNotEmpty) {
      int result = 0;
      for (var element in autoTrackTypeList) {
        switch (element) {
          case HAAutoTrackType.TYPE_NONE:
            result |= 0;
            break;
          case HAAutoTrackType.APP_START:
            result |= 1;
            break;
          case HAAutoTrackType.APP_END:
            result |= 1 << 1;
            break;
          case HAAutoTrackType.APP_CLICK:
            result |= 1 << 2;
            break;
          case HAAutoTrackType.APP_VIEW_SCREEN:
            result |= 1 << 3;
            break;
        }
      }
      return result;
    } else {
      return -1;
    }
  }

  static int getNetworkTypes(Set<HANetworkType>? networkTypeList) {
    if (networkTypeList != null && networkTypeList.isNotEmpty) {
      int result = 0;
      for (var element in networkTypeList) {
        switch (element) {
          case HANetworkType.TYPE_NONE:
            result |= 0;
            break;
          case HANetworkType.TYPE_2G:
            result |= 1;
            break;
          case HANetworkType.TYPE_3G:
            result |= 1 << 1;
            break;
          case HANetworkType.TYPE_4G:
            result |= 1 << 2;
            break;
          case HANetworkType.TYPE_5G:
            result |= 1 << 4;
            break;
          case HANetworkType.TYPE_WIFI:
            result |= 1 << 3;
            break;
          case HANetworkType.TYPE_ALL:
            result |= 0xFF;
            break;
        }
      }
      return result;
    } else {
      return -1;
    }
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
