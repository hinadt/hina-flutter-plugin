import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hina_flutter_plugin/hina_flutter_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    print('======== init web =========');
    HinaFlutterPlugin.callMethodForWeb('init', [{
      'serverUrl': 'https://loanetc.mandao.com/hn?token=BHRfsTQS',
      'showLog' : true,
      //单页面配置，默认开启，若页面中有锚点设计，需要将该配置删除，否则触发锚点会多触发 H_pageview 事件
      'isSinglePage': true,
      'autoTrackConfig': {
        //是否开启自动点击采集, true表示开启，自动采集 H_WebClick 事件
        'clickAutoTrack': true,
        //是否开启页面停留采集, true表示开启，自动采集 H_WebStay 事件
        'stayAutoTrack': true,
      }
    }]);
  } else {
    HinaFlutterPlugin.initForMobile(
        serverUrl: "https://loanetc.mandao.com/hn?token=BHRfsTQS",
        flushInterval: 5000,
        flushPendSize: 1,
        enableLog: true,
        autoTrackTypeList: {
          HAAutoTrackType.APP_START,
          HAAutoTrackType.APP_END
        });
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  Map<String, dynamic>? _presetProperties = {};

  // final _hinaFlutterPlugin = HinaFlutterPlugin();

  @override
  void initState() {
    super.initState();
    //
    initPlatformState();
    //
    HinaFlutterPlugin.registerCommonProperties({'app_name': '张三啦啦啦'});

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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Scrollbar(
            child: ListView(
              children: <Widget>[
                Text(
                  'Run on $_platformVersion',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                TextButton(onPressed: _buttonGetPresetProperties, child: const Text('getPresetProperties')),
                TextButton(onPressed: _buttonGetDeviceUId, child: const Text('getDeviceUId')),
                TextButton(onPressed: _buttonSetDeviceUId, child: const Text('set DeviceUId == dededededededede')),
                TextButton(onPressed: _buttonSetUserUId, child: const Text('set userUId == 1234567890')),
                TextButton(onPressed: _buttonTrack, child: const Text('track')),
                TextButton(onPressed: _buttonTrackTimerStart, child: const Text('track timer start')),
                TextButton(onPressed: _buttonTrackTimerEnd, child: const Text('track timer end')),
                TextButton(onPressed: _buttonSet, child: const Text('userSet')),
                TextButton(onPressed: _buttonSetOnce, child: const Text('userSetOnce')),
                TextButton(onPressed: _buttonAdd, child: const Text('userAdd')),
                TextButton(onPressed: _buttonAppend, child: const Text('userAppend(待验证)')),
                TextButton(onPressed: _buttonUnset, child: const Text('userUnset')),
                TextButton(onPressed: _buttonDelete, child: const Text('userDelete')),
                TextButton(onPressed: _buttonFlush, child: const Text('flush')),
                TextButton(onPressed: _buttonClear, child: const Text('clear')),
              ],
        ))),

      ),
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

  void _buttonTrack() {
    HinaFlutterPlugin.track('clickPro',
        {'ProductID': '123456', 'ProductCatalog': 'Laptop Computer'});
  }

  void _buttonTrackTimerStart() {
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
    // List<String> values = ['哪吒脑海', '冰雪奇缘'];
    // HinaFlutterPlugin.userAppend("movie", values);
    // todo 统一json参数
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
