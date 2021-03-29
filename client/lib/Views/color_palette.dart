import 'package:flutter/material.dart';

enum ColorPalette {
  black,
  white,
  torea_bay,
  endeavour,
  congress_blue,
  french_pass,
  malibu,
  orange
}

extension ColorPaletteExtension on ColorPalette {
  Color get rgb {
    switch (this) {
      case ColorPalette.black:
        return const Color(0xff000000);
      case ColorPalette.white:
        return const Color(0xffffffff);
      case ColorPalette.torea_bay:
        return const Color(0xff1e408e);
      case ColorPalette.endeavour:
        return const Color(0xff0066b3);
      case ColorPalette.congress_blue:
        return const Color(0xff0066b3);
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
