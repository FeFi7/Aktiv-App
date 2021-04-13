import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:flutter/material.dart';

class RoundedDatepickerButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const RoundedDatepickerButton({
    Key key,
    this.text,
    this.press,
    this.color,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 10), //Abstand um den Button herum (oben/unten)
      width: size.width * 0.8,
      height: 58,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        // ignore: deprecated_member_use
        child: FlatButton(
          padding: EdgeInsets.symmetric(
              vertical: 20, horizontal: 27.5), //max Höhe/Breite
          color: color,
          onPressed: press,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: ColorPalette.torea_bay.rgb,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 0, horizontal: 17), //max Höhe/Breite
                  child: Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
