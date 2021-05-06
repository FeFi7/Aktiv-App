import 'package:flutter/material.dart';

enum ColorPalette {
  black,
  light_grey,
  grey,
  dark_grey,
  white,
  torea_bay,
  endeavour,
  congress_blue,
  french_pass,
  malibu,
  orange
}

// Farbpalette für Einheitliches Farbschema
extension ColorPaletteExtension on ColorPalette {
  Color get rgb {
    switch (this) {
      case ColorPalette.black:
        return const Color(0xff000000);
        case ColorPalette.light_grey:
        return const Color(0xffDDDDDD);
        case ColorPalette.grey:
        return const Color(0xffAAAAAA);
        case ColorPalette.dark_grey:
        return const Color(0xff555555);
      case ColorPalette.white:
        return const Color(0xffffffff);
      case ColorPalette.torea_bay:
        return const Color(0xff1e408e);
      case ColorPalette.endeavour:
        return const Color(0xff0066b3);
      case ColorPalette.congress_blue:
        return const Color(0xff00487d);
      case ColorPalette.french_pass:
        return const Color(0xffbfe4ff);
      case ColorPalette.malibu:
        return const Color(0xff80c9ff);
      case ColorPalette.orange:
        return const Color(0xffff8000);
      default:
        return null;
    }
  }
}
