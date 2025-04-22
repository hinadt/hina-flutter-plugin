import 'package:flutter/material.dart';

class HNElementPath {
  HNElementPath._(this._element);
  factory HNElementPath.createFrom({
    required Element element,
    required Element pageElement,
  }) {
    HNElementPath path = HNElementPath._(element);
    path._element = element;
    bool searchTarget = true;
    element.visitAncestorElements((parent) {
      if (parent.widget is GestureDetector) {
        searchTarget = false;
      }
      if (searchTarget && _HNPathConstants.levelSet.contains(parent.widget.runtimeType)) {
        path._element = parent;
      }
      if (parent == pageElement) {
        return false;
      }
      return true;
    });
    return path;
  }
  Element _element;
  Element get element => _element;
}

class _HNPathConstants {
  static final Set<Type> levelSet = {
    IconButton,
    TextButton,
    InkWell,
    ElevatedButton,
    ListTile,
  };
}