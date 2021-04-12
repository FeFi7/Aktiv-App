import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/components/rounded_datepicker_button.dart';
import 'package:aktiv_app_flutter/components/rounded_input_email_field.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field.dart';
import 'package:flutter/material.dart';

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
    return Column(
      children: [
        RoundedInputField(
          hintText: "Titel",
          icon: Icons.edit,
          onChanged: (value) {},
        ),
        RoundedInputField(
          hintText: "Beschreibung",
          icon: Icons.edit,
          onChanged: (value) {},
        ),
        RoundedInputEmailField(
          hintText: "Kontakt",
          icon: Icons.email,
          onChanged: (value) {},
        ),
        RoundedInputField(
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
          textColor: ColorPalette.black.rgb,
          press: () async{
            await _selectDate(context);
            setState(() {
              starttext = currentDate.day.toString() +
                  "." +
                  currentDate.month.toString() +
                  "." +
                  currentDate.year.toString() +
                  ", " +
                  currentTime.hour.toString() +
                  ":" +
                  currentTime.minute.toString();
            });
          },
        ),
        RoundedDatepickerButton(
          text: endtext,
          color: ColorPalette.malibu.rgb,
          textColor: ColorPalette.black.rgb,
          press: ()async {
            await _selectDate(context);

            setState(() {
              endtext = currentDate.day.toString() +
                  "." +
                  currentDate.month.toString() +
                  "." +
                  currentDate.year.toString() +
                  ", " +
                  currentTime.hour.toString() +
                  ":" +
                  currentTime.minute.toString();
            });
          },
        ),
      ],
    );
  }
}
