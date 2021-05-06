import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key key,
    this.child,
  }) : super(key: key);

  //TextField Container mit vordefiniertem Design
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 10), //Abstand um das Textfeld (oben/unten)
      padding:
          EdgeInsets.symmetric(horizontal: 20, vertical: 5), //max. Höhe/Breite
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: ColorPalette.malibu.rgb,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
