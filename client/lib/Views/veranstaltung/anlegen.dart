import 'package:aktiv_app_flutter/Views/Home.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/veranstaltung/detail.dart';
import 'package:aktiv_app_flutter/components/rounded_button_dynamic.dart';
import 'package:aktiv_app_flutter/components/rounded_datepicker_button.dart';
import 'package:aktiv_app_flutter/components/rounded_input_email_field.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field_beschreibung.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field_numeric.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class VeranstaltungAnlegenView extends StatefulWidget {
  const VeranstaltungAnlegenView();
  @override
  _VeranstaltungAnlegenViewState createState() =>
      _VeranstaltungAnlegenViewState();
}

class _VeranstaltungAnlegenViewState extends State<VeranstaltungAnlegenView> {
  DateTime currentDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String starttext = "Beginn";
  String endtext = "Ende";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2050));

    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
    await _selectTime(context);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (selectedTime != null && selectedTime != currentTime)
      setState(() {
        currentTime = selectedTime;
      });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          RoundedInputField(
            hintText: "Titel",
            icon: Icons.title,
            onChanged: (value) {},
          ),
          RoundedInputFieldBeschreibung(
            hintText: 'Beschreibung der Veranstaltung',
            icon: Icons.edit,
          ),
          RoundedInputEmailField(
            hintText: "Kontakt",
            icon: Icons.email,
            onChanged: (value) {},
          ),
          RoundedInputFieldNumeric(
            hintText: "Postleitzahl",
            icon: Icons.home,
            onChanged: (value) {},
          ),
          RoundedInputField(
            hintText: "Adresse",
            icon: Icons.location_on_rounded,
            onChanged: (value) {},
          ),
          RoundedDatepickerButton(
            text: starttext,
            color: ColorPalette.malibu.rgb,
            textColor: Colors.black54,
            press: () async {
              await _selectDate(context);
              setState(() {
                String minute = currentTime.minute.toString();
                if (currentTime.minute.toString().length == 1) {
                  minute = '0' + currentTime.minute.toString();
                }
                starttext = currentDate.day.toString() +
                    "." +
                    currentDate.month.toString() +
                    "." +
                    currentDate.year.toString() +
                    ", " +
                    currentTime.hour.toString() +
                    ":" +
                    minute;
              });
            },
          ),
          RoundedDatepickerButton(
            text: endtext,
            color: ColorPalette.malibu.rgb,
            textColor: Colors.black54,
            press: () async {
              await _selectDate(context);

              setState(() {
                String minute = currentTime.minute.toString();
                if (currentTime.minute.toString().length == 1) {
                  minute = '0' + currentTime.minute.toString();
                }
                endtext = currentDate.day.toString() +
                    "." +
                    currentDate.month.toString() +
                    "." +
                    currentDate.year.toString() +
                    ", " +
                    currentTime.hour.toString() +
                    ":" +
                    minute;
              });
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: RoundedButtonDynamic(
                width: size.width * 0.4,
                text: 'Speichern',
                color: ColorPalette.orange.rgb,
                textColor: Colors.white,
                press: () {
                  setState(() {
                        Fluttertoast.showToast(
                            msg: "Veranstaltung gespeichert!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: ColorPalette.white.rgb,
                            textColor: ColorPalette.orange.rgb);
                      });
                  // Austauschen durch Event Provider sobald fertig
                  Provider.of<BodyProvider>(context, listen: false)
                              .setBody(VeranstaltungDetailView());
                          Provider.of<AppBarTitleProvider>(context,
                                  listen: false)
                              .setTitle('Übersicht');
                }),
          ),
        ],
      ),
    );
  }
}
