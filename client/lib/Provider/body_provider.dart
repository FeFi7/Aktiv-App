import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BodyProvider extends ChangeNotifier {
  Widget _body = Text('404');

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
