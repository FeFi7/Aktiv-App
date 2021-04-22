import 'dart:convert';

import 'package:aktiv_app_flutter/Provider/body_provider.dart';
import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:aktiv_app_flutter/Views/Home.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/veranstaltung/detail.dart';
import 'package:aktiv_app_flutter/components/rounded_button_dynamic.dart';
import 'package:aktiv_app_flutter/components/rounded_datepicker_button.dart';
import 'package:aktiv_app_flutter/components/rounded_input_email_field.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field_beschreibung.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field_numeric.dart';
import 'package:aktiv_app_flutter/util/rest_api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../../util/rest_api_service.dart';

class VeranstaltungAnlegenView extends StatefulWidget {
  const VeranstaltungAnlegenView();
  @override
  _VeranstaltungAnlegenViewState createState() =>
      _VeranstaltungAnlegenViewState();
}

class _VeranstaltungAnlegenViewState extends State<VeranstaltungAnlegenView> {
  DateTime currentDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
 //int id = 0;
  String starttext = "Beginn";
  String endtext = "Ende";
  String titel = "Titel",
      beschreibung = "Beschreibung der Veranstaltung",
      email = "test@testmail.de",
      plz = "00000",
      adresse = "Adresse",
      start = "Start",
      ende = "Ende";
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
            onChanged: (value) {
              titel = value;
            },
          ),
          RoundedInputFieldBeschreibung(
            hintText: 'Beschreibung der Veranstaltung',
            icon: Icons.edit,
            onChanged: (value) {
              beschreibung = value;
            },
          ),
          RoundedInputEmailField(
            hintText: "Kontakt",
            icon: Icons.email,
            onChanged: (value) {
              email = value;
            },
          ),
          RoundedInputFieldNumeric(
            hintText: "Postleitzahl",
            icon: Icons.home,
            onChanged: (value) {
              plz = value;
            },
          ),
          RoundedInputField(
            hintText: "Adresse",
            icon: Icons.location_on_rounded,
            onChanged: (value) {
              adresse = value;
            },
          ),
          RoundedDatepickerButton(
            text: starttext,
            color: ColorPalette.malibu.rgb,
            textColor: Colors.black54,
            press: () async {
              await _selectDate(context);
              setState(() {
                String minute = currentTime.minute.toString();
                String hour = currentTime.hour.toString();
                String month = currentDate.month.toString();
                String day = currentDate.day.toString();

                if (currentTime.minute.toString().length == 1) {
                  minute = '0' + currentTime.minute.toString();
                }
                if (currentTime.hour.toString().length == 1) {
                  hour = '0' + currentTime.hour.toString();
                }
                if (currentDate.month.toString().length == 1) {
                  month = '0' + currentDate.month.toString();
                }
                if (currentDate.day.toString().length == 1) {
                  day = '0' + currentDate.day.toString();
                }
                starttext = day +
                    "." +
                    month +
                    "." +
                    currentDate.year.toString() +
                    ", " +
                    hour +
                    ":" +
                    minute;
                start = currentDate.year.toString() +
                    "-" +
                    month +
                    "-" +
                    day +
                    " " +
                    hour +
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
                String hour = currentTime.hour.toString();
                String month = currentDate.month.toString();
                String day = currentDate.day.toString();
                if (currentTime.minute.toString().length == 1) {
                  minute = '0' + currentTime.minute.toString();
                }
                if (currentTime.hour.toString().length == 1) {
                  hour = '0' + currentTime.hour.toString();
                }
                if (currentDate.month.toString().length == 1) {
                  month = '0' + currentDate.month.toString();
                }
                if (currentDate.day.toString().length == 1) {
                  day = '0' + currentDate.day.toString();
                }

                endtext = day +
                    "." +
                    month +
                    "." +
                    currentDate.year.toString() +
                    ", " +
                    hour +
                    ":" +
                    minute;
                ende = currentDate.year.toString() +
                    "-" +
                    month +
                    "-" +
                    day +
                    " " +
                    hour +
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
                press: () async {
                  Provider.of<EventProvider>(context,listen: false).createEvent(titel, beschreibung, email, start, ende, adresse).then((event) =>{
                
                    Provider.of<BodyProvider>(context, listen: false)
                      .setBody(VeranstaltungDetailView(event.id))
                 // Provider.of<AppBarTitleProvider>(context, listen: false)
                 //     .setTitle('Übersicht');


                  });
                  
                  setState(() {
                    Fluttertoast.showToast(
                        msg: "Test",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 2,
                        backgroundColor: ColorPalette.white.rgb,
                        textColor: ColorPalette.orange.rgb);
                  });
                }),
          ),
        ],
      ),
    );
  }
}
