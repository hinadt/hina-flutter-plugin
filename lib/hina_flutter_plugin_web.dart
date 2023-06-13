import 'dart:html' as html show window;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'hina_flutter_plugin_platform_interface.dart';

class HinaFlutterPluginWeb extends HinaFlutterPluginPlatform {
  HinaFlutterPluginWeb();

  static void registerWith(Registrar registrar) {
    // HinaFlutterPluginPlatform.instance = HinaFlutterPluginWeb();
    const MethodChannel channel = MethodChannel("hina_flutter_plugin"); //通讯channel
    final webPlugin = HinaFlutterPluginWeb();
    channel.setMethodCallHandler(webPlugin.handler);// 消息处理
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  Future<dynamic> handler(MethodCall call) {
    List list = call.arguments;
    switch (call.method) {
      case "getPlatformVersion":
        return Future(() => getPlatformVersion());
        break;
      case "init":
        // init(list, result);
        break;
      case "track":
        // track(list);
        break;
      case "trackTimerStart":
        // trackTimerStart(list);
        break;
      case "trackTimerEnd":
        // trackTimerEnd(list);
        break;
      case "getPresetProperties":
        // getPresetProperties(result);
        break;
      case "registerCommonProperties":
        // registerCommonProperties(list);
        break;
      case "userSet":
        // userSet(list);
        break;
      case "userSetOnce":
        // userSetOnce(list);
        break;
      case "userAdd":
        // userAdd(list);
        break;
      case "userAppend":
        // userAppend(list);
        break;
      case "userUnset":
        // userUnset(list);
        break;
      case "userDelete":
        // userDelete();
        break;
      case "setUserUId":
        // setUserUId(list);
        break;
      case "setPushUId":
        // setPushUId(list);
        break;
      case "setDeviceUId":
        // setDeviceUId(list);
        break;
      case "getDeviceUId":
        // getDeviceUId(result);
        break;
      case "setFlushPendSize":
        // setFlushPendSize(list);
        break;
      case "setFlushInterval":
        // setFlushInterval(list);
        break;
      case "setFlushNetworkPolicy":
        // setFlushNetworkPolicy(list);
        break;
      case "flush":
        // flush();
        break;
      case "clear":
        // clear();
        break;
      default:
        // result.notImplemented();
        break;
    }
    return Future(() => '');
  }
}