import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'hina_flutter_plugin_platform_interface.dart';

/// An implementation of [HinaFlutterPluginPlatform] that uses method channels.
class MethodChannelHinaFlutterPlugin extends HinaFlutterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('hina_flutter_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
