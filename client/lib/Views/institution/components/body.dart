import 'dart:convert';

import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/institution/components/background.dart';
import 'package:aktiv_app_flutter/components/rounded_button.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field_beschreibung_institution.dart';
import 'package:aktiv_app_flutter/util/rest_api_service.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final titelController = TextEditingController();
  final beschreibungController = TextEditingController();

  String titel = "Titel", beschreibung = "Beschreibung der Veranstaltung";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Institution beantragen",
              style: TextStyle(color: ColorPalette.black.rgb, fontSize: 26.0),
            ),
            SizedBox(height: size.height * 0.03), //Abstand unter den Buttons
            RoundedInputField(
              hintText: "Titel",
              icon: Icons.title,
              onChanged: (value) {
                titelController.text = value;
              },
            ),
            RoundedInputFieldBeschreibungInstitution(
              hintText: 'Beschreibung der Institution',
              icon: Icons.edit,
              onChanged: (value) {
                beschreibungController.text = value;
              },
            ),
            RoundedButton(
              text: "Institutionsantrag abschicken",
              color: ColorPalette.endeavour.rgb,
              press: () async {
                if (await confirm(
                  context,
                  title: Text("Bestätigung"),
                  content:
                      Text("Möchten Sie die Institution wirklich beantragen?"),
                  textOK: Text(
                    "Bestätigen",
                    style: TextStyle(color: ColorPalette.grey.rgb),
                  ),
                  textCancel: Text(
                    "Abbrechen",
                    style: TextStyle(color: ColorPalette.endeavour.rgb),
                  ),
                )) {
                  var jwt = await attemptCreateInstitution(
                      titelController.text,
                      beschreibungController.text,
                      await Provider.of<UserProvider>(context, listen: false)
                          .getAccessToken());
                  if (jwt.statusCode != 200) {
                    var error = json.decode(jwt.body);
                    errorToast(error['error'].toString());
                  } else {
                    errorToast("erfolgreich beantragt");
                  }
                }
              },
            ),
          ],
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
