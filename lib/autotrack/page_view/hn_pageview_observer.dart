import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:hina_flutter_plugin/autotrack/page_view/hn_page_stack.dart';
import 'package:hina_flutter_plugin/autotrack/utils/hn_element_utils.dart';
import 'package:hina_flutter_plugin/hina_autotrack.dart';
import 'package:hina_flutter_plugin/hina_autotrack_config.dart';

class HinaNavigatorObserver extends NavigatorObserver {
  
  static List<NavigatorObserver> wrap(List<NavigatorObserver>? navigatorObservers) {
    if (navigatorObservers == null) {
      return [HinaNavigatorObserver()];
    }

    bool found = false;
    List<NavigatorObserver> removeList = [];
    for (NavigatorObserver observer in navigatorObservers) {
      if (observer is HinaNavigatorObserver) {
        if (found) {
          removeList.add(observer);
        }
        found = true;
      }
    }
    for (NavigatorObserver observer in removeList) {
      navigatorObservers.remove(observer);
    }
    if (!found) {
      navigatorObservers.insert(0, HinaNavigatorObserver());
    }
    return navigatorObservers;
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    try {
      this._findElement(route, (element) {
        HNPageStack.instance.push(route, element, previousRoute);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    try {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        HNPageStack.instance.pop(route, previousRoute);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    try {
      HNPageStack.instance.remove(route, previousRoute);
    } catch (e) {
      print(e);
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    try {
      this._findElement(newRoute!, (element) {
        HNPageStack.instance.replace(newRoute, element, oldRoute);
      });
    } catch (e) {
      print(e);
    }
  }

  void _findElement(Route route, Function(Element) result) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // check ModelRoute first
      if (route is ModalRoute) {
        ModalRoute pageRoute = route;
        HNElementUtils.walk(pageRoute.subtreeContext, (element, parent) {
          if (parent != null && parent.widget is Semantics) {
            result(element);
            return false;
          }
          return true;
        });
      } else if (HNAutoTrackManager.instance.config.useCustomRoute) {
        List<HNAutoTrackPageConfig> pageConfigs = HNAutoTrackManager.instance.config.pageConfigs;
        if (pageConfigs.isEmpty) {
          return;
        }

        Element? lastPageElement;
        HNElementUtils.walk(route.navigator?.context, (element, parent) {
          if (pageConfigs.last.isPageWidget(element.widget)) {
            lastPageElement = element;
            return false;
          }
          return true;
        });
        if (lastPageElement != null) {
          result(lastPageElement!);
        }
      }
    });
  }
}