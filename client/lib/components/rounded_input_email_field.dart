import 'package:aktiv_app_flutter/components/text_field_container.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class RoundedInputEmailField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  const RoundedInputEmailField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          validator: (value) => EmailValidator.validate(value)
              ? null
              : "Bitte gültige Email eingeben",
          onChanged: onChanged,
          decoration: InputDecoration(
            icon: Icon(
              icon,
              color: ColorPalette.torea_bay.rgb,
            ),
            hintText: hintText,
            border: InputBorder.none,
          ),
          controller: controller,
        ),
      ),
    );
  }
}
