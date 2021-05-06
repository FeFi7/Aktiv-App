import 'package:aktiv_app_flutter/components/text_field_container.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class RoundedInputFieldNumericKomma extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  bool enabled = false;
  RoundedInputFieldNumericKomma({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.controller,
    this.enabled,
  }) : super(key: key);

  //Abgerundetes InputField mit vordefiniertem Design Keyboard-Type (numerisch), ohne Einschränkung
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        enabled: enabled,
        onChanged: onChanged,
        controller: controller,
        keyboardType: TextInputType.number, //nur Eingabe von Zahlen möglich
        decoration: InputDecoration(
          //Icon des InputFields
          icon: Icon(
            icon,
            color: ColorPalette.torea_bay.rgb,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
