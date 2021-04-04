import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      color: ColorPalette.endeavour.rgb,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          child,
        ],
      ),
    );
  }
}
