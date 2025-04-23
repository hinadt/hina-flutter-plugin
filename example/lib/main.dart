import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hina_flutter_plugin/hina_flutter_plugin.dart';
import 'package:hina_flutter_plugin/autotrack/page_view/hn_pageview_observer.dart';
import 'package:hina_flutter_plugin_example/pages/about.dart';
import 'package:hina_flutter_plugin_example/pages/home.dart';
import 'package:hina_flutter_plugin_example/pages/settings.dart';

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
        serverUrl: "https://test-hicloud.hinadt.com/gateway/hina-cloud-engine/ha?project=new_category&token=ui5scybH",
        flushInterval: 5000,
        flushPendSize: 1,
        enableLog: true,
        enableTrackAppCrash: true,
        autoTrackConfig: HNAutoTrackConfig(pageConfigs: [
          HNAutoTrackPageConfig<HomeScreen>(title: '首页www', screenName: '首页home', properties: {'pageId':'home001'}, ignore: false)
        ]),
        autoTrackTypeList: {
          HAAutoTrackType.APP_START,
          HAAutoTrackType.APP_VIEW_SCREEN,
          HAAutoTrackType.APP_CLICK,
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

  // final _hinaFlutterPlugin = HinaFlutterPlugin();

  @override
  void initState() {
    super.initState();
    //
    HinaFlutterPlugin.registerCommonProperties({'app_name': '张三啦啦啦'});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: HinaNavigatorObserver.wrap([]),
      routes: {
        '/': (context) => HomeScreen(),
        '/settings': (context) => Settings(),
        '/about': (context) => About(),
      },
    );
  }
}
