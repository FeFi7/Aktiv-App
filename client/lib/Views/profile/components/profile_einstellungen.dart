import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:flutter/material.dart';

class ProfileEinstellungen extends StatefulWidget {
  ProfileEinstellungen({Key key}) : super(key: key);

  @override
  _ProfileEinstellungenState createState() => _ProfileEinstellungenState();
}

class _ProfileEinstellungenState extends State<ProfileEinstellungen> {
  var sliderValueNaehe = 0.0;
  var sliderValueBald = 1.0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: 40),
        Container(
          child: Align(
            child: Material(
              color: ColorPalette.white.rgb,
              elevation: 10.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: ColorPalette.malibu.rgb,
              child: Container(
                  width: size.width * 0.8,
                  height: 200.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: Text(
                            "Bald",
                            style: TextStyle(
                                color: ColorPalette.endeavour.rgb,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Slider(
                            min: 1.0,
                            max: 30.0,
                            divisions: 30,
                            value: sliderValueBald,
                            activeColor: ColorPalette.malibu.rgb,
                            inactiveColor: ColorPalette.endeavour.rgb,
                            onChanged: (value) {
                              setState(() => sliderValueBald = value);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                            child: Text(
                          "In: ${(sliderValueBald).round()}" + " Tag(en)",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ],
                  )),
            ),
          ),
        ),
        SizedBox(height: 25),
        Container(
          child: Align(
            child: Material(
              color: ColorPalette.white.rgb,
              elevation: 10.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: ColorPalette.malibu.rgb,
              child: Container(
                  width: size.width * 0.8,
                  height: 200.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: Text(
                            "In der Nähe",
                            style: TextStyle(
                                color: ColorPalette.endeavour.rgb,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Slider(
                            min: 0.0,
                            max: 100.0,
                            divisions: 20,
                            value: sliderValueNaehe,
                            activeColor: ColorPalette.malibu.rgb,
                            inactiveColor: ColorPalette.endeavour.rgb,
                            onChanged: (value) {
                              if (mounted)
                                setState(() => sliderValueNaehe = value);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                            child: Text(
                          "Entfernung: ${(sliderValueNaehe).round()}" + " km",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
