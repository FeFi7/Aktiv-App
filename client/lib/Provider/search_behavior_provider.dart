import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:flutter/material.dart';

enum SearchStyle { FULLTEXT, DATE, PERIOD }

class SearchBehaviorProvider extends ChangeNotifier {
  final List<bool> isSelected = [true, false, false];

  static SearchStyle _style = SearchStyle.FULLTEXT;
  static SearchStyle get style => _style;

  // Buttons für die Entdecken View, die darüber entscheiden wie (Volltext/Datum/Zeitraum) gesucht wird
  Widget getToggleButtons() {
    return Container(
      margin: const EdgeInsets.all(2.0),
      height: 40,
      child: ToggleButtons(
        children: [
          Container(
              padding: const EdgeInsets.all(5.0), width: 110, child: Center(child: Text('Allgemein'))),
          Container(padding: const EdgeInsets.all(5.0), width: 110, child: Center(child: Text('Datum'))),
          Container(
              padding: const EdgeInsets.all(5.0), width: 110, child: Center(child: Text('Zeitraum'))),
        ],
        isSelected: isSelected,
        onPressed: (int index) {
          for (int buttonIndex = 0;
              buttonIndex < isSelected.length;
              buttonIndex++) {
            if (buttonIndex == index) {
              isSelected[buttonIndex] = true;
            } else {
              isSelected[buttonIndex] = false;
            }
            _style = SearchStyle.values[index];
          }
          notifyListeners();
        },
        borderRadius: BorderRadius.circular(30),
        borderWidth: 1,
        selectedColor: ColorPalette.white.rgb,
        fillColor: ColorPalette.endeavour.rgb,
        color: ColorPalette.endeavour.rgb,
        disabledColor: ColorPalette.endeavour.rgb,
      ),
    );
  }
}
