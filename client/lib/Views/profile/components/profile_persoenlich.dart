import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field_numeric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePersoenlich extends StatefulWidget {
  ProfilePersoenlich({Key key}) : super(key: key);

  @override
  _ProfilePersoenlichState createState() => _ProfilePersoenlichState();
}

class _ProfilePersoenlichState extends State<ProfilePersoenlich> {
  int currentStep = 0; //startIndex für Stepper
  bool complete = false; //Ausfüllen abgeschlossen?
  static String vorname;
  static String nachname;
  static String plz;
  static String tel;
  static String ort;
  static String hausnummer;
  static String strasse;

  @override
  Widget build(BuildContext context) {
    if (Provider.of<UserProvider>(context, listen: false).vorname != null) {
      vorname = Provider.of<UserProvider>(context, listen: false).vorname;
    }
    if (Provider.of<UserProvider>(context, listen: false).nachname != null) {
      nachname = Provider.of<UserProvider>(context, listen: false).nachname;
    }
    if (Provider.of<UserProvider>(context, listen: false).plz != null) {
      plz = Provider.of<UserProvider>(context, listen: false).plz.toString();
    }
    if (Provider.of<UserProvider>(context, listen: false).tel != null) {
      tel = Provider.of<UserProvider>(context, listen: false).tel;
    }
    if (Provider.of<UserProvider>(context, listen: false).ort != null) {
      ort = Provider.of<UserProvider>(context, listen: false).ort;
    }
    if (Provider.of<UserProvider>(context, listen: false).hausnummer != null) {
      hausnummer = Provider.of<UserProvider>(context, listen: false)
          .hausnummer
          .toString();
    }
    if (Provider.of<UserProvider>(context, listen: false).strasse != null) {
      strasse = Provider.of<UserProvider>(context, listen: false).strasse;
    }

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
                              setState(() {
                                complete = false;
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .updateUserInfo(
                                        vorname, nachname, plz, tel);
                              });
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
                          TextButton(
                            onPressed: onStepContinue,
                            child: const Text(
                              'Weiter',
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
                    steps: steps,
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

  nextStep() {
    currentStep + 1 != steps.length
        ? goToStep(currentStep + 1)
        : setState(() => complete = true);
  }

  cancelStep() {
    if (currentStep > 0) {
      goToStep(currentStep - 1);
    }
  }

  goToStep(int step) {
    setState(() => currentStep = step);
  }

  List<Step> steps = [
    Step(
      title: Text("Person"),
      content: Column(
        children: <Widget>[
          RoundedInputField(
            hintText: hintVorname(vorname),
            onChanged: (value) {
              vorname = value;
            },
          ),
          RoundedInputField(
            hintText: hintNachname(nachname),
            onChanged: (value) {
              nachname = value;
            },
          ),
          RoundedInputFieldNumeric(
            hintText: hintTel(tel),
            icon: Icons.phone,
            onChanged: (value) {
              tel = value;
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
            hintText: hintStrasse(strasse),
            icon: Icons.home,
            onChanged: (value) {
              strasse = value;
            },
          ),
          RoundedInputFieldNumeric(
            hintText: hintHausnummer(hausnummer),
            icon: Icons.home,
            onChanged: (value) {
              hausnummer = value;
            },
          ),
          RoundedInputFieldNumeric(
            hintText: hintPlz(plz),
            icon: Icons.gps_fixed_outlined,
            onChanged: (value) {
              plz = value;
            },
          ),
          RoundedInputField(
            hintText: hintOrt(ort),
            icon: Icons.gps_fixed_outlined,
            onChanged: (value) {
              ort = value;
            },
          ),
        ],
      ),
    ),
  ];
}

hintVorname<String>(vorname) {
  if (vorname != null) {
    return vorname;
  } else
    return "Vorname";
}

hintNachname<String>(nachname) {
  if (nachname != null) {
    return nachname;
  } else
    return "Nachname";
}

hintTel<String>(tel) {
  if (tel != null) {
    return tel;
  } else
    return "Telefonnummer";
}

hintStrasse<String>(strasse) {
  if (strasse != null) {
    return strasse;
  } else
    return "Straße";
}

hintHausnummer<String>(hausnummer) {
  if (hausnummer != null) {
    return hausnummer;
  } else
    return "Hausnummer";
}

hintPlz<String>(plz) {
  if (plz != null) {
    return plz;
  } else
    return "PLZ";
}

hintOrt<String>(ort) {
  if (ort != null) {
    return ort;
  } else
    return "Ort";
}
