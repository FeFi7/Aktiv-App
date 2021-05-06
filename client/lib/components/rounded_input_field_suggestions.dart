import 'package:aktiv_app_flutter/components/text_field_container.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

class RoundedInputFieldSuggestions extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final List<String> suggestions;
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const RoundedInputFieldSuggestions({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.suggestions,
    this.controller,
    this.onSubmitted,
  }) : super(key: key);

//Abgerundetes InputField mit vordefiniertem Design und Vorschlägen für Tags
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: SimpleAutoCompleteTextField(
        controller: controller,
        key: key,
        suggestions: suggestions, //Liste der Vorschläge
        textChanged: onChanged,
        textSubmitted: onSubmitted,
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
