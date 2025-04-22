import 'package:flutter/widgets.dart';

class HNAutoTrackConfig {

HNAutoTrackConfig({
    this.pageConfigs = const [],
    this.useCustomRoute = false,
  });

  List<HNAutoTrackPageConfig> pageConfigs;
  //if use Route out of MaterialPageRoute/PageRoute/ModalRoute, must set this switch to true, and all pages should be set in pageConfigs
  bool useCustomRoute;
}

class HNAutoTrackPageConfig<T extends Widget> {
  
  HNAutoTrackPageConfig({
    String? title,
    String? screenName,
    Map<String, dynamic>? properties,
    bool ignore = false,
  })  : ignore = ignore {
    this.title = title;
    this.screenName = screenName;
    this.properties = properties;
  }

  String? title;
  String? screenName;
  Map<String, dynamic>? properties;
  bool ignore;

  bool isPageWidget(Widget pageWidget) => pageWidget is T;
}

class HNElementKey extends Key {
  final String key;
  final Map<String, dynamic>? properties;
  final bool isIgnore;
  HNElementKey(this.key, {this.properties, this.isIgnore = false}) : super.empty();
}