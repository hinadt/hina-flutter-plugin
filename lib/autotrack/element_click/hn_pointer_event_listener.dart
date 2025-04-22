import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:hina_flutter_plugin/autotrack/page_view/hn_page_stack.dart';
import 'package:hina_flutter_plugin/autotrack/utils/hn_element_utils.dart';
import 'package:hina_flutter_plugin/hina_autotrack.dart';

class HNPointerEventListener {

  static HNPointerEventListener instance = HNPointerEventListener._();
  HNPointerEventListener._();
  _HNTapGestureRecognizer _tapGestureRecognizer = _HNTapGestureRecognizer();
  bool _started = false;

  void start() {
    if (_started) {
      return;
    }
    GestureBinding.instance.pointerRouter.addGlobalRoute(_pointerRoute);
    _tapGestureRecognizer.dispose();
    _started = true;
  }

  void stop() {
    if (!_started) {
      return;
    }
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_pointerRoute);
    _tapGestureRecognizer.dispose();
    _started = false;
  }

  void _pointerRoute(PointerEvent event) {
    try {
      if (event is PointerDownEvent) {
        _tapGestureRecognizer.addPointer(event);
      } else if (event is PointerUpEvent) {
        _tapGestureRecognizer.checkPointerUpEvent(event);
        PointerDownEvent? pointerDownEvent = _tapGestureRecognizer.lastPointerDownEvent;
        if (event.pointer != _tapGestureRecognizer.rejectPointer && pointerDownEvent != null) {
          _checkElementAndTrack(pointerDownEvent, event);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _checkElementAndTrack(PointerDownEvent downEvent, PointerUpEvent upEvent) {
    final currentPage = HNPageStack.instance.currentPage();
    if (currentPage == null) {
      return;
    }

    LinkedList<_HNHitEntry> hits = LinkedList();
    HNElementUtils.walkElement(currentPage.element, (child,_) {
      if (child is RenderObjectElement && child.renderObject is RenderBox) {
        RenderBox renderBox = child.renderObject as RenderBox;
        if (!renderBox.hasSize) {
          return false;
        }
        Offset localPosition = renderBox.globalToLocal(upEvent.position);
        if (!renderBox.size.contains(localPosition)) {
          return false;
        }
        if (renderBox is RenderPointerListener) {
          hits.add(_HNHitEntry(child));
        }
      }
      return true;
    });
    if (hits.isEmpty) {
      return;
    }

    _HNHitEntry? entry = hits.last;
    Element? gestureElement;
    while (entry != null) {
      gestureElement = HNElementUtils.findAncestorElementOfWidgetType<GestureDetector>(entry.element);
      if (gestureElement != null) {
        break;
      }
      entry = entry.previous;
    }
    if (gestureElement != null) {
      //track click event
      HNFlutterAutoTrackerPlugin.instance.trackElementClick(gestureElement, currentPage.element, currentPage.info);
    }
  }
}

class _HNTapGestureRecognizer extends TapGestureRecognizer {
  _HNTapGestureRecognizer({Object? debugOwner}) : super(debugOwner: debugOwner);

  PointerDownEvent? lastPointerDownEvent;
  int rejectPointer = 0;

  void checkPointerUpEvent(PointerUpEvent upEvent) {
    if (lastPointerDownEvent == null) {
      return;
    }
    
    Offset downEventPosition = lastPointerDownEvent!.position;
    Offset upEventPosition = upEvent.position;
    double offset = (downEventPosition.dx - upEventPosition.dx).abs() + (downEventPosition.dy - upEventPosition.dy).abs();
    if (offset > 30) {
      rejectGesture(upEvent.pointer);
    }
  }

  @override
  void addPointer(PointerDownEvent event) {
    lastPointerDownEvent = event;
    super.addPointer(event);
  }

  @override
  void rejectGesture(int pointer) {
    if (lastPointerDownEvent?.pointer == pointer) {
      lastPointerDownEvent = null;
    }
    rejectPointer = pointer;
    super.rejectGesture(pointer);
  }
}

class _HNHitEntry extends LinkedListEntry<_HNHitEntry> {
  _HNHitEntry(this.element);
  final Element element;
}