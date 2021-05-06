import 'package:aktiv_app_flutter/components/text_field_container.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundedInputFieldNumeric extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  const RoundedInputFieldNumeric({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  //Abgerundetes InputField mit vordefiniertem Design Keyboard-Type (numerisch), mit Einschränkungen
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(
              RegExp(r'[0-9]')), //Einschräkung der Eingabe (nur Zahlen)
        ],
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
