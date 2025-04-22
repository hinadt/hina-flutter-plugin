import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hina_flutter_plugin/autotrack/element_click/hn_element_path.dart';
import 'package:hina_flutter_plugin/autotrack/element_click/hn_pointer_event_listener.dart';
import 'package:hina_flutter_plugin/autotrack/page_view/hn_page_stack.dart';
import 'package:hina_flutter_plugin/autotrack/utils/hn_element_utils.dart';
import 'package:hina_flutter_plugin/hina_flutter_plugin.dart';
import 'package:hina_flutter_plugin/hina_autotrack_config.dart';

class HNAutoTrackManager {
  static final HNAutoTrackManager instance = HNAutoTrackManager._();
  HNAutoTrackManager._();
  HNAutoTrackConfig _config = HNAutoTrackConfig();

  bool _enableElementClick = false;
  bool _enablePageView = false;
  
  HNAutoTrackConfig get config => _config;
  set config(HNAutoTrackConfig config) {
    _config = config;
  }

  void enablePageView(bool enable) {
    _enablePageView = enable;
  }

  bool get pageViewEnabled => _enablePageView;

  void enableElementClick(bool enable) {
    _enableElementClick = enable;
    if (enable) {
      HNPointerEventListener.instance.start();
    } else {
      HNPointerEventListener.instance.stop();
    }
  }

  bool get elementClickEnabled => _enableElementClick;

  HNAutoTrackPageConfig findPageConfig(Widget pageWidget) {
    return _config.pageConfigs.firstWhere((element) => element.isPageWidget(pageWidget), orElse: () => HNAutoTrackPageConfig());
  }
}

class HNFlutterAutoTrackerPlugin {
  static final HNFlutterAutoTrackerPlugin instance = HNFlutterAutoTrackerPlugin._();
  HNFlutterAutoTrackerPlugin._();

  void trackPageView(HNPageInfo pageInfo) {
    if (!HNAutoTrackManager.instance.pageViewEnabled) {
      return;
    }
    Map<String, dynamic> properties = _getPropertiesFromPageInfo(pageInfo);
    properties.addAll(pageInfo.properties ?? {});
    properties[r'H_lib_method'] = 'autoTrack';
    HinaFlutterPlugin.track(kIsWeb ? r'H_pageview' : r'H_AppViewScreen', properties);
  }

  void trackElementClick(Element gestureElement, Element pageElement, HNPageInfo pageInfo) {
    if (!HNAutoTrackManager.instance.elementClickEnabled) {
      return;
    }
    Element element = HNElementPath.createFrom(element: gestureElement, pageElement: pageElement).element;
    bool isIgnore = false;
    Key? key = element.widget.key;
    Map<String, dynamic> properties = Map();
    if (key is HNElementKey) {
      isIgnore = key.isIgnore;
      properties.addAll(key.properties ?? {});
    }
    if (isIgnore) {
      return;
    }
    properties.addAll(_getPropertiesFromPageInfo(pageInfo));
    properties[r'H_element_content'] = HNElementUtils.findTexts(element).join('-');
    properties[r'H_element_type'] = element.widget.runtimeType.toString();
    properties[r'H_lib_method'] = 'autoTrack';
    HinaFlutterPlugin.track(kIsWeb ? r'H_WebClick' : r'H_AppClick', properties);
  }

  Map<String, dynamic> _getPropertiesFromPageInfo(HNPageInfo pageInfo) {
    Map<String, dynamic> properties = Map();
    properties[r'H_title'] = pageInfo.title;
    properties[r'H_screen_name'] = pageInfo.screenName;
    return properties;
  }
}