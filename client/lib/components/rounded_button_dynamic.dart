import 'package:flutter/material.dart';

class RoundedButtonDynamic extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final EdgeInsets margin;
  final double width;
  const RoundedButtonDynamic({
    Key key,
    this.text,
    this.press,
    this.color,
    this.textColor = Colors.white, 
    this.margin,
    this.width,

    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin:EdgeInsets.only(right:size.width*0.1),
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        // ignore: deprecated_member_use
        child: FlatButton(
          padding: EdgeInsets.symmetric(
              vertical: 20, horizontal: 40), //max Höhe/Breite
          color: color,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}