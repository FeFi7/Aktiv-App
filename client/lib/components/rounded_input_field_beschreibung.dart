import 'package:aktiv_app_flutter/components/text_field_container.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:flutter/material.dart';

class RoundedInputFieldBeschreibung extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputFieldBeschreibung({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Padding(
            padding: const EdgeInsets.only(left: 0 , top: 8 , right: 0, bottom: 100),
            child: Icon(
              
              icon,
              color: ColorPalette.torea_bay.rgb,
            ),
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
        maxLines: 6,
        maxLength: 420,
      ),
    );
  }
}
