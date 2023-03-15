import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hina_flutter_plugin/hina_flutter_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  // final _hinaFlutterPlugin = HinaFlutterPlugin();

  @override
  void initState() {
    super.initState();
    HinaFlutterPlugin.init(
        serverUrl: "https://loanetc.mandao.com/hn?token=BHRfsTQS",
        flushInterval: 5000,
        flushPendSize: 1,
        enableLog: true);
    //
    initPlatformState();
    //
    HinaFlutterPlugin.registerCommonProperties({'app_name': '张三啦啦啦'});
    HinaFlutterPlugin.setDeviceUId("dedededededede");
    HinaFlutterPlugin.setUserUId("1234567890");
    HinaFlutterPlugin.track('eventname',
        {'ProductID': '123456', 'ProductCatalog': 'Laptop Computer'});
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
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
