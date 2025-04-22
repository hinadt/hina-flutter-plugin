
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hina_flutter_plugin/hina_flutter_plugin.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  Map<String, dynamic>? _presetProperties = {};

  String _platformVersion = 'Unknown';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await HinaFlutterPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
          child: Scrollbar(
              child: ListView(
                children: <Widget>[
                  GestureDetector(child: Text(
                    'Run on $_platformVersion',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),onTap: () {
                    Navigator.of(context).pushNamed('/settings');
                  },),
                  TextButton(onPressed: _buttonGetPresetProperties, child: const Text('getPresetProperties')),
                  TextButton(onPressed: _buttonGetDeviceUId, child: const Text('getDeviceUId')),
                  TextButton(onPressed: _buttonSetDeviceUId, child: const Text('set DeviceUId == dededededededede')),
                  TextButton(onPressed: _buttonSetUserUId, child: const Text('set userUId == 1234567890')),
                  TextButton(onPressed: _buttonCleanUserUId, child: const Text('cleanUserUId')),
                  TextButton(onPressed: _buttonTrack, child: const Text('track')),
                  TextButton(onPressed: _buttonTrackTimerStart, child: const Text('track timer start')),
                  TextButton(onPressed: _buttonTrackTimerEnd, child: const Text('track timer end')),
                  TextButton(onPressed: _buttonSet, child: const Text('userSet')),
                  TextButton(onPressed: _buttonSetOnce, child: const Text('userSetOnce')),
                  TextButton(onPressed: _buttonAdd, child: const Text('userAdd')),
                  TextButton(onPressed: _buttonAppend, child: const Text('userAppend')),
                  TextButton(onPressed: _buttonUnset, child: const Text('userUnset')),
                  TextButton(onPressed: _buttonDelete, child: const Text('userDelete')),
                  TextButton(onPressed: _buttonFlush, child: const Text('flush')),
                  TextButton(onPressed: _buttonClear, child: const Text('clear')),
                ],
              ))),

    );
  }
  void _buttonGetPresetProperties() {
    HinaFlutterPlugin.getPresetProperties().then((value) => print(value));
  }

  void _buttonGetDeviceUId() {
    HinaFlutterPlugin.getDeviceUId().then((value) => print(value));
  }

  void _buttonSetDeviceUId() {
    HinaFlutterPlugin.setDeviceUId('dededededededede');
  }

  void _buttonSetUserUId() {
    HinaFlutterPlugin.setUserUId('1234567890');
  }

  void _buttonCleanUserUId() {
    HinaFlutterPlugin.cleanUserUId();
  }

  void _buttonTrack() {
    HinaFlutterPlugin.track('click_test',
        {"strList":["aaa","bbb"],'numList': [1,2,3], 'objList': [{'a':'b'},{"c":1}]});
  }

  void _buttonTrackTimerStart() {
    print('_buttonTrackTimerStart');
    HinaFlutterPlugin.trackTimerStart("dingo");
  }

  void _buttonTrackTimerEnd() {
    var p = <String, dynamic>{};
    p["from"] = 'black';
    HinaFlutterPlugin.trackTimerEnd('dingo', p);
  }

  void _buttonSet() {
    var p = <String, dynamic>{};
    p["user_name"] = '张三';
    HinaFlutterPlugin.userSet(p);
  }

  void _buttonSetOnce() {
    var p = <String, dynamic>{};
    p["user_register_time"] = '10101010';
    HinaFlutterPlugin.userSetOnce(p);
  }

  void _buttonAdd() {
    var p = <String, num>{};
    p['score'] = 8;
    HinaFlutterPlugin.userAdd(p);
  }

  void _buttonAppend() {
    List<String> values = ['西游记', '三国演义'];
    HinaFlutterPlugin.userAppend("books", values);
  }

  void _buttonUnset() {
    HinaFlutterPlugin.userUnset("user_name");
  }

  void _buttonDelete() {
    HinaFlutterPlugin.userDelete();
  }

  void _buttonFlush() {
    HinaFlutterPlugin.flush();
  }

  void _buttonClear() {
    HinaFlutterPlugin.clear();
  }
}