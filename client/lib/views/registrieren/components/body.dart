import 'package:aktiv_app_flutter/components/rounded_input_email_field.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field.dart';
import 'package:aktiv_app_flutter/components/rounded_password_field.dart';
import 'package:aktiv_app_flutter/Views/Login/login_screen.dart';
import 'package:aktiv_app_flutter/Views/Registrieren/components/background.dart';
import 'package:aktiv_app_flutter/components/account_vorhanden_check.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentStep = 0; //startIndex für Stepper
  bool complete = false; //Registrierung abgeschlossen?
  static TextEditingController password = TextEditingController();
  static TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            complete
                ? Center(
                    child: AlertDialog(
                      title: Text("Registrierung abgeschlossen"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text("Danke für die Registrierung."),
                            Text("Sie werden zurück zur Login Seite geleitet")
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              complete = false;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginScreen();
                                  },
                                ),
                              );
                            },
                            child: Text("Weiterleiten"))
                      ],
                    ),
                  )
                : Stepper(
                    steps: steps,
                    currentStep: currentStep,
                    onStepContinue: nextStep,
                    onStepCancel: cancelStep,
                    onStepTapped: (step) => goToStep(step),
                  ),
            SizedBox(height: size.height * 0.03), //Abstand unter den Buttons
            //Zurück zum LoginScreen
            AccountBereitsVorhandenCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(
                height: size.height * 0.03), //Abstand über der Pop-Up Tastatur
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
      title: Text("Account"),
      content: Column(
        children: <Widget>[
          RoundedInputEmailField(
            hintText: "Email",
            icon: Icons.mail,
            onChanged: (value) {},
          ),
          RoundedPasswordField(
            hintText: "Passwort",
            onChanged: (value) {
              password.text = value;
            },
          ),
          RoundedPasswordField(
            hintText: "Passwort wiederholen",
            onChanged: (value) {
              confirmPassword.text = value;
            },
          ),
        ],
      ),
    ),
    Step(
      title: Text("Person"),
      content: Column(
        children: <Widget>[
          RoundedInputField(
            hintText: "Vorname",
            onChanged: (value) {},
          ),
          RoundedInputField(
            hintText: "Nachname",
            onChanged: (value) {},
          ),
          RoundedInputField(
            hintText: "Telefonnummer",
            icon: Icons.phone,
            onChanged: (value) {},
          ),
        ],
      ),
    ),
    Step(
      title: Text("Anschrift"),
      content: Column(
        children: <Widget>[
          RoundedInputField(
            hintText: "Straße, Hausnummer",
            icon: Icons.home,
            onChanged: (value) {},
          ),
          RoundedInputField(
            hintText: "PLZ, Ort",
            icon: Icons.gps_fixed_outlined,
            onChanged: (value) {},
          ),
        ],
      ),
    ),
  ];
}
