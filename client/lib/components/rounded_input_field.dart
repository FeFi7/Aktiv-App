import 'package:aktiv_app_flutter/components/text_field_container.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final TextEditingController controller;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.onSubmitted,
    this.controller,
  }) : super(key: key);

  //Abgerundetes InputField mit vordefiniertem
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        controller: controller,
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
