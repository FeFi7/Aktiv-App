import 'package:flutter/widgets.dart';

class ClickerProvider extends ChangeNotifier {
  int _count = 0;

  int get count => this._count;

  void incrementCounter() {
    _count += 1;
    notifyListeners();
  }

  void clearCount() {
    _count = 0;
    notifyListeners();
  }
}
