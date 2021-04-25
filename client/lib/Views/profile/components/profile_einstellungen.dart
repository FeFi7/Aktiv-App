import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

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
        baldSlider(size),
        SizedBox(height: 25),
        naeheSlider(size),
        SizedBox(
          height: 25,
        ),
        RoundedButton(
          text: "Einstellungen übernehmen",
          color: ColorPalette.endeavour.rgb,
          press: () async {
            var jwt = await Provider.of<UserProvider>(context, listen: false)
                .updateUserSettings(sliderValueNaehe.toInt().toString(),
                    sliderValueBald.toInt().toString());
            if (jwt.statusCode != 200) errorToast("Fehler bei Aktualisierung");
          },
        ),
      ],
    );
  }

  Container naeheSlider(Size size) {
    return Container(
      child: Align(
        child: Material(
          color: ColorPalette.white.rgb,
          elevation: 5.0,
          borderRadius: BorderRadius.circular(24.0),
          shadowColor: ColorPalette.malibu.rgb,
          child: Container(
            width: size.width * 0.8,
            height: 120.0,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "In der Nähe:\t",
                                style: TextStyle(
                                  color: ColorPalette.endeavour.rgb,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "${(sliderValueNaehe).round()}" +
                                    " km entfernt",
                                style: TextStyle(
                                    color: ColorPalette.black.rgb,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Slider(
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      value: sliderValueNaehe,
                      activeColor: ColorPalette.malibu.rgb,
                      inactiveColor: ColorPalette.endeavour.rgb,
                      onChanged: (value) {
                        setState(() => sliderValueNaehe = value);
                      },
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

  Container baldSlider(Size size) {
    return Container(
      child: Align(
        child: Material(
          color: ColorPalette.white.rgb,
          elevation: 5.0,
          borderRadius: BorderRadius.circular(24.0),
          shadowColor: ColorPalette.malibu.rgb,
          child: Container(
            width: size.width * 0.8,
            height: 120.0,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Bald:\t",
                                style: TextStyle(
                                  color: ColorPalette.endeavour.rgb,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "in ${(sliderValueBald).round()}" +
                                    " Tag(en)",
                                style: TextStyle(
                                    color: ColorPalette.black.rgb,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Slider(
                      min: 1.0,
                      max: 31.0,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  errorToast(String errorMessage) {
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: ColorPalette.orange.rgb,
      textColor: ColorPalette.white.rgb,
    );
    FocusManager.instance.primaryFocus.unfocus();
  }
}
