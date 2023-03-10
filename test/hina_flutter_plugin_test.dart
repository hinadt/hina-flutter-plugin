import 'package:flutter_test/flutter_test.dart';
import 'package:hina_flutter_plugin/hina_flutter_plugin.dart';
import 'package:hina_flutter_plugin/hina_flutter_plugin_platform_interface.dart';
import 'package:hina_flutter_plugin/hina_flutter_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHinaFlutterPluginPlatform
    with MockPlatformInterfaceMixin
    implements HinaFlutterPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HinaFlutterPluginPlatform initialPlatform = HinaFlutterPluginPlatform.instance;

  test('$MethodChannelHinaFlutterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHinaFlutterPlugin>());
  });

  test('getPlatformVersion', () async {
    HinaFlutterPlugin hinaFlutterPlugin = HinaFlutterPlugin();
    MockHinaFlutterPluginPlatform fakePlatform = MockHinaFlutterPluginPlatform();
    HinaFlutterPluginPlatform.instance = fakePlatform;

    expect(await hinaFlutterPlugin.getPlatformVersion(), '42');
  });
}
