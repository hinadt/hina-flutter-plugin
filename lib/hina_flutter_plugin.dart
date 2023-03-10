
import 'hina_flutter_plugin_platform_interface.dart';

class HinaFlutterPlugin {
  Future<String?> getPlatformVersion() {
    return HinaFlutterPluginPlatform.instance.getPlatformVersion();
  }
}
