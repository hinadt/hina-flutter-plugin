import 'dart:collection';
import 'package:flutter/widgets.dart';
import 'package:hina_flutter_plugin/autotrack/utils/hn_element_utils.dart';
import 'package:hina_flutter_plugin/hina_autotrack.dart';
import 'package:hina_flutter_plugin/hina_autotrack_config.dart';


enum _HNPageRoutetype {
  push,
  pop,
  remove,
  replace,
}

class HNPageStack {
  
  static final instance = HNPageStack();
  LinkedList<_HNPage> _pages = LinkedList<_HNPage>();
  _HNPageTask _task = _HNPageTask();

  void push(Route route, Element element, Route? previousRoute) {
    _HNPage page = _HNPage.create(route, element);
    _pages.add(page);
    _task.addPush(page, page.previous);
  }

  void pop(Route route, Route? previousRoute) {
    if (_pages.isEmpty) {
      return;
    }
    _HNPage? page = _findPage(route);
    if (page != null) {
      _task.addPop(page, page.previous);
    }
    _removeAllAfter(page);
  }

  void remove(Route route, Route? previousRoute) {
    if (_pages.isEmpty) {
      return;
    }
    _HNPage? page = _findPage(route);
    if (page != null) {
      _pages.remove(page);
    }
  }

  void replace(Route newRoute, Element newElement, Route? oldRoute) {
    _HNPage newPage = _HNPage.create(newRoute, newElement);
    _HNPage? oldPage;
    if (oldRoute != null) {
      oldPage = _findPage(oldRoute);
      _removeAllAfter(oldPage);
    }
    _pages.add(newPage);
    _task.addReplace(newPage, oldPage);
  }

  _HNPage? _findPage(Route route) {
    if (_pages.isEmpty) {
      return null;
    }
    _HNPage? lastPage = _pages.last;
    while (lastPage != null) {
      if (lastPage.route == route) {
        return lastPage;
      }
      lastPage = lastPage.previous;
    }
    return null;
  }

  _HNPage? currentPage() {
    return _pages.isEmpty ? null : _pages.last;
  }

  _removeAllAfter(_HNPage? page) {
    while (page != null) {
      _pages.remove(page);
      page = page.next;
    }
  }
}

class _HNPage extends LinkedListEntry<_HNPage> {
  
  _HNPage._({
    required this.info,
    required this.route,
    required this.element,
  });

  final HNPageInfo info;
  final Route route;
  final Element element;

  factory _HNPage.create(Route route, Element element) {
    return _HNPage._(
      info: HNPageInfo.getInfo(route, element),
      route: route,
      element: element,
    );
  }
}

class HNPageInfo {
  
  HNPageInfo._();

  factory HNPageInfo.getInfo(Route route, Element element) {
    HNAutoTrackPageConfig pageConfig = HNAutoTrackManager.instance.findPageConfig(element.widget);
    HNPageInfo info = HNPageInfo._();
    info.title = pageConfig.title ?? (HNElementUtils.findTitle(element) ?? '');
    info.screenName = pageConfig.screenName ?? element.widget.runtimeType.toString();
    info.ignore = pageConfig.ignore;
    info.properties = pageConfig.properties;
    return info;
  }

  String title = '';
  String screenName = '';
  bool ignore = false;
  Map<String, dynamic>? properties;
}

class _HNPageTask {
  
  List<_HNPageTaskData> _taskDatas = [];
  bool _isTaskRunning = false;

  void addPush(_HNPage page, _HNPage? previousPage) {
    _HNPageTaskData taskData = _HNPageTaskData(page: page, type: _HNPageRoutetype.push);
    taskData.previousPage = previousPage;
    _taskDatas.add(taskData);
    startTask();
  }

  void addPop(_HNPage page, _HNPage? previousPage) {
    _HNPageTaskData taskData = _HNPageTaskData(page: page, type: _HNPageRoutetype.pop);
    taskData.previousPage = previousPage;
    _taskDatas.add(taskData);
    startTask();
  }

  void addReplace(_HNPage page, _HNPage? previousPage) {
    _HNPageTaskData taskData = _HNPageTaskData(page: page, type: _HNPageRoutetype.replace);
    taskData.previousPage = previousPage;
    _taskDatas.add(taskData);
    startTask();
  }

  void addRemove(_HNPage page, _HNPage? previousPage) {
  }

  void startTask() {
    if (_isTaskRunning) {
      return;
    }
    _isTaskRunning = true;
    Future.delayed(Duration(milliseconds: 30), () {
      _runTask();
    });
  }

  void _runTask() {
    if (_taskDatas.isEmpty) {
      _isTaskRunning = false;
      return;
    }
    List list = _taskDatas.sublist(0);
    //use leavePage to track PageLeave in the future
    _HNPage? enterPage, leavePage;
    _taskDatas.clear();
    for (_HNPageTaskData data in list) {
      switch (data.type) {
        case _HNPageRoutetype.push:
        if (leavePage == null) {
          leavePage = data.previousPage;
        }
          enterPage = data.page;
          break;
        case _HNPageRoutetype.pop:
        if (leavePage == null) {
          leavePage = data.page;
        }
        if (enterPage == null || enterPage == data.page) {
          enterPage = data.previousPage;
        }
          break;
        case _HNPageRoutetype.replace:
        if (leavePage == null) {
          leavePage = data.previousPage;
        }
        if (enterPage == null || enterPage == data.previousPage) {
          enterPage = data.page;
        }
          break;
        case _HNPageRoutetype.remove:
          break;
      }
    }
    
    if (enterPage == leavePage) {
      _isTaskRunning = false;
      return;
    }
    //track page enter
    if (enterPage !=null && !enterPage.info.ignore) {
      HNFlutterAutoTrackerPlugin.instance.trackPageView(enterPage.info);
    }
    //track page leave
    if (leavePage != null && !leavePage.info.ignore) {
      
    }
    _isTaskRunning = false;
    
  }
}

class _HNPageTaskData {
  _HNPageTaskData({
    required this.page,
    required this.type,
  });
  final _HNPageRoutetype type;
  final _HNPage page;
  _HNPage? previousPage;
}