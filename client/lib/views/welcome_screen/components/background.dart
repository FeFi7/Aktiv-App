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
      decoration: BoxDecoration(color: ColorPalette.torea_bay.rgb),
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            bottom: 5,
            right: 5,
            child: Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "powered by \nLEBENSQUALITÄT \nBURGRIEDEN e.V.",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: ColorPalette.endeavour.rgb,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                SizedBox(
                    width: size.width *
                        0.03), //Abstand zwischen Text und Logo (Rechts unten)
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset("assets/images/lq_logo_klein.png"),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
