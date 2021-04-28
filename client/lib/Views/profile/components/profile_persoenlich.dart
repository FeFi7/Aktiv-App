import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field_numeric.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ProfilePersoenlich extends StatefulWidget {
  ProfilePersoenlich({Key key}) : super(key: key);

  @override
  _ProfilePersoenlichState createState() => _ProfilePersoenlichState();
}

class _ProfilePersoenlichState extends State<ProfilePersoenlich> {
  var jwt;
  int currentStep = 0; //startIndex für Stepper
  bool complete = false; //Ausfüllen abgeschlossen?
  static String vorname;
  static String nachname;
  static String plz;
  static String tel;
  static String ort;
  static String hausnummer;
  static String strasse;

  List<Step> steps;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            complete
                ? Center(
                    child: AlertDialog(
                      title: Text("Angaben vollständig"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                                "Vielen Dank für die Vervollständigung Ihrer angaben.\nSie haben nun die Möglichkeit, Veranstaltungen anzulegen."),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              setState(
                                () {
                                  complete = false;
                                },
                              );
                            },
                            child: Text("Bestätigen"))
                      ],
                    ),
                  )
                : Stepper(
                    controlsBuilder: (BuildContext context,
                        {VoidCallback onStepContinue,
                        VoidCallback onStepCancel}) {
                      return Row(
                        children: <Widget>[
                          currentStep + 1 != steps.length
                              ? TextButton(
                                  onPressed: onStepContinue,
                                  child: const Text(
                                    'Weiter',
                                    style: TextStyle(
                                      color: Colors.orange,
                                    ),
                                  ),
                                )
                              : TextButton(
                                  onPressed: onStepContinue,
                                  child: const Text(
                                    'Daten senden',
                                    style: TextStyle(
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                          TextButton(
                            onPressed: onStepCancel,
                            child: const Text(
                              'Zurück',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    steps: steps = [
                      Step(
                        title: Text("Person"),
                        content: Column(
                          children: <Widget>[
                            RoundedInputField(
                              hintText: hintVorname(Provider.of<UserProvider>(
                                      context,
                                      listen: false)
                                  .vorname
                                  .toString()),
                              onChanged: (value) {
                                if (value != null && value != "null") {
                                  vorname = value;
                                }
                              },
                            ),
                            RoundedInputField(
                              hintText: hintNachname(Provider.of<UserProvider>(
                                      context,
                                      listen: false)
                                  .nachname
                                  .toString()),
                              onChanged: (value) {
                                if (value != null && value != "null") {
                                  nachname = value;
                                }
                              },
                            ),
                            RoundedInputFieldNumeric(
                              hintText: hintTel(Provider.of<UserProvider>(
                                      context,
                                      listen: false)
                                  .tel
                                  .toString()),
                              icon: Icons.phone,
                              onChanged: (value) {
                                if (value != null && value != "null") {
                                  tel = value;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Step(
                        title: Text("Anschrift"),
                        content: Column(
                          children: <Widget>[
                            RoundedInputField(
                              hintText: hintStrasse(Provider.of<UserProvider>(
                                      context,
                                      listen: false)
                                  .strasse
                                  .toString()),
                              icon: Icons.home,
                              onChanged: (value) {
                                if (value != null && value != "null") {
                                  strasse = value;
                                }
                              },
                            ),
                            RoundedInputFieldNumeric(
                              hintText: hintHausnummer(
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .hausnummer
                                      .toString()),
                              icon: Icons.home,
                              onChanged: (value) {
                                if (value != null && value != "null") {
                                  hausnummer = value;
                                }
                              },
                            ),
                            RoundedInputFieldNumeric(
                              hintText: hintPlz(Provider.of<UserProvider>(
                                      context,
                                      listen: false)
                                  .plz
                                  .toString()),
                              icon: Icons.gps_fixed_outlined,
                              onChanged: (value) {
                                if (value != null && value != "null") {
                                  plz = value;
                                }
                              },
                            ),
                            RoundedInputField(
                              hintText: hintOrt(Provider.of<UserProvider>(
                                      context,
                                      listen: false)
                                  .ort
                                  .toString()),
                              icon: Icons.gps_fixed_outlined,
                              onChanged: (value) {
                                if (value != null && value != "null") {
                                  ort = value;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                    currentStep: currentStep,
                    onStepContinue: nextStep,
                    onStepCancel: cancelStep,
                    onStepTapped: (step) => goToStep(step),
                  ),
          ],
        ),
      ),
    );
  }

  nextStep() async {
    if (currentStep + 1 != steps.length) {
      goToStep(currentStep + 1);
    } else {
      var jwt = await Provider.of<UserProvider>(context, listen: false)
          .updateUserInfo(vorname, nachname, plz, tel);
      if (jwt.statusCode == 200) {
        setState(() => complete = true);
      } else {
        errorToast("Übertragung fehlgeschlagen");
      }
    }
  }

  cancelStep() {
    if (currentStep > 0) {
      goToStep(currentStep - 1);
    }
  }

  goToStep(int step) {
    setState(() => currentStep = step);
  }
}

hintVorname<String>(vorname) {
  if (vorname != null && vorname != "null") {
    return vorname;
  } else
    return "Vorname";
}

hintNachname<String>(nachname) {
  if (nachname != null && nachname != "null") {
    return nachname;
  } else
    return "Nachname";
}

hintTel<String>(tel) {
  if (tel != null && tel != "null") {
    return tel;
  } else
    return "Telefonnummer";
}

hintStrasse<String>(strasse) {
  if (strasse != null && strasse != "null") {
    return strasse;
  } else
    return "Straße";
}

hintHausnummer<String>(hausnummer) {
  if (hausnummer != null && hausnummer != "null") {
    return hausnummer;
  } else
    return "Hausnummer";
}

hintPlz<String>(plz) {
  if (plz != null && plz != "null") {
    return plz;
  } else
    return "PLZ";
}

hintOrt<String>(ort) {
  if (ort != null && ort != "null") {
    return ort;
  } else
    return "Ort";
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
