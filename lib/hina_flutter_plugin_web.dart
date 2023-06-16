import 'dart:convert';
import 'dart:html' as html show window;
import 'dart:js' as js;
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'hina_flutter_plugin_platform_interface.dart';

class HinaFlutterPluginWeb extends HinaFlutterPluginPlatform {

  js.JsObject hina = js.context['hinaDataStatistic'];

  HinaFlutterPluginWeb();

  static void registerWith(Registrar registrar) {
    // HinaFlutterPluginPlatform.instance = HinaFlutterPluginWeb();
    MethodChannel channel = MethodChannel("hina_flutter_plugin",
      StandardMethodCodec(),
      registrar,
    ); //通讯channel
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
    List? list = call.arguments;
    print('============ call method：${call.method}');
    print('============ call arguments：${call.arguments}');
    if (call.method == 'getPlatformVersion') {
      final version = html.window.navigator.userAgent;
      return Future.value(version);
    } else if (call.method == 'getPresetProperties') {
      js.JsObject object = hina.callMethod('getPresetProperties');
      String result = js.context['JSON'].callMethod('stringify', [object]);
      Map<String, dynamic> map = json.decode(result);
      return Future.value(map);
    } else {
      if (list != null) {
        for (int i = 0; i < list.length; i++) {
          if (list[i] is Map) {
            String jsonString = json.encode(list[i]);
            var object = js.context['JSON'].callMethod('parse', [jsonString]);
            list[i] = object;
          }
        }
      }
    }
    return Future(() => hina.callMethod(call.method, list));
  }
}