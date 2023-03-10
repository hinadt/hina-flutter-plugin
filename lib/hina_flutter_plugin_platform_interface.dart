import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hina_flutter_plugin_method_channel.dart';

abstract class HinaFlutterPluginPlatform extends PlatformInterface {
  /// Constructs a HinaFlutterPluginPlatform.
  HinaFlutterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static HinaFlutterPluginPlatform _instance = MethodChannelHinaFlutterPlugin();

  /// The default instance of [HinaFlutterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelHinaFlutterPlugin].
  static HinaFlutterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HinaFlutterPluginPlatform] when
  /// they register themselves.
  static set instance(HinaFlutterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
