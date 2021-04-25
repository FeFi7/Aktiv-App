import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field_numeric.dart';
import 'package:aktiv_app_flutter/util/rest_api_service.dart';
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

                //ToDo: Wenn User Provider done, Daten ergänzen
                // attemptUpdateUserInfo(
                //     mail, vorname, nachname, plz, tel, userId, accessToken),
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
            hintText: "Vorname",
            onChanged: (value) {
              vorname = value;
            },
          ),
          RoundedInputField(
            hintText: "Nachname",
            onChanged: (value) {
              nachname = value;
            },
          ),
          RoundedInputFieldNumeric(
            hintText: "Telefonnummer",
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
            hintText: "Straße",
            icon: Icons.home,
            onChanged: (value) {
              strasse = value;
            },
          ),
          RoundedInputFieldNumeric(
            hintText: "Hausnummer",
            icon: Icons.home,
            onChanged: (value) {
              hausnummer = value;
            },
          ),
          RoundedInputFieldNumeric(
            hintText: "PLZ",
            icon: Icons.gps_fixed_outlined,
            onChanged: (value) {
              plz = value;
            },
          ),
          RoundedInputField(
            hintText: "Ort",
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
