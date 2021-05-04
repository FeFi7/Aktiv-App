import 'dart:collection';

import 'package:aktiv_app_flutter/Views/defaults/error_preview_box.dart';
import 'package:flutter/material.dart';

class BodyProvider extends ChangeNotifier {
  StatefulWidget _body = ErrorPreviewBox("404");

  ListQueue previous = ListQueue<Widget>();

  /// Wenn der Getter mit "Widget get body => this._body;"
  /// erstellt wird, kommt ein Stack Overflow ¯\_(ツ)_/¯
  Widget getBody() {
    return this._body;
  }

  void setBody(Widget body) {
    previous.add(this._body);
    this._body = body;

    notifyListeners();
  }

  void resetBody(Widget body) {
    previous.clear();
    this._body = body;

    notifyListeners();
  }

  void initializeBody(Widget body) {
    this._body = body;
  }

  void previousBody(BuildContext context) {
    if (previous.length > 0) {
      this._body = previous.removeLast();
    } else {
      Navigator.of(context).pop();
    }

    notifyListeners();
  }
}
