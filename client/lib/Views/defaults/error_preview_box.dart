import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:flutter/material.dart';

import 'color_palette.dart';

class ErrorPreviewBox extends StatefulWidget {
  String reason;

  ErrorPreviewBox(this.reason);

  @override
  _ErrorPreviewBoxState createState() => _ErrorPreviewBoxState();
}

// TODO: Box Höhe muss noch fix weden, passt sich momentan noch der Höhe an

class _ErrorPreviewBoxState extends State<ErrorPreviewBox> {
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;

    return SizedBox(

      child: Container(
        // heightFactor: 1,
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        height: 10,
        child: SizedBox(
          height: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: ColorPalette.orange.rgb),
            child: Container(
               padding: const EdgeInsets.all(10.0),
              child: Column(
               
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                      child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Keine Veranstaltung gefunden",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.white.rgb),
                      maxLines: 6,
                      overflow:
                          TextOverflow.ellipsis, //Macht ... bei zu langem Texts
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
                        style:
                            TextStyle(fontSize: 15, color: ColorPalette.white.rgb),
                        maxLines: 6,
                        overflow:
                            TextOverflow.ellipsis, //Macht ... bei zu langem Texts
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
