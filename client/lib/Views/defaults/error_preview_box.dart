
import 'package:flutter/material.dart';

import 'color_palette.dart';

// ignore: must_be_immutable
class ErrorPreviewBox extends StatefulWidget {
  String header, reason;

  ErrorPreviewBox(this.reason, [this.header="Keine Veranstaltung gefunden"]);

  @override
  _ErrorPreviewBoxState createState() => _ErrorPreviewBoxState();
}

class _ErrorPreviewBoxState extends State<ErrorPreviewBox> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size.width*0.9,
            height: size.width*0.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: ColorPalette.orange.rgb),
            padding: const EdgeInsets.all(10.0),
            margin: EdgeInsets.all(10),
            child: Column(

              children: <Widget>[
                SizedBox(
                    child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.header,
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.white.rgb),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis, //Macht ... bei zu langem Texts
                    textAlign: TextAlign.justify,
                  ),
                )),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                      child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.reason,
                      style: TextStyle(fontSize: 15, color: ColorPalette.white.rgb),
                      maxLines: 6,
                      overflow:
                          TextOverflow.ellipsis, //Macht ... bei zu langem Texts
                    ),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
