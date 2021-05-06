import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:flutter/material.dart';

class RoundedButtonDynamic extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final EdgeInsets margin;
  final double width;
  final double textSize;
  final IconData icon;
  const RoundedButtonDynamic({
    Key key,
    this.text,
    this.press,
    this.color,
    this.textColor = Colors.white,
    this.margin,
    this.width,
    this.textSize,
    this.icon,
  }) : super(key: key);

  //Abgerundeter Button mit vordefiniertem Design
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Container(
      // margin:EdgeInsets.only(right:size.width*0.1),
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        // ignore: deprecated_member_use
        child: FlatButton(
          padding: EdgeInsets.symmetric(
              vertical: 17, horizontal: 0), //max Höhe/Breite
          color: color,
          onPressed: press,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                //Icon im Button
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: Icon(
                    icon,
                    color: ColorPalette.torea_bay.rgb,
                  ),
                ),
                //Textinhalt des Buttons
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 0, horizontal: 5), //max Höhe/Breite
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
