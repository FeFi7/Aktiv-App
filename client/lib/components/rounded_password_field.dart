import 'package:aktiv_app_flutter/components/text_field_container.dart';
import 'package:aktiv_app_flutter/views/defaults/color_palette.dart';
import 'package:flutter/material.dart';

class RoundedPasswordField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.hintText,
    this.icon = Icons.lock,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

//Abgerundetes InputField mit vordefiniertem Design für Passwörter
//mit Möglichkeit, die Eingabe sichtbar/zensiert anzuzeigen
class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool passwordObscure =
      true; //passwordObscure lässt die Eingabe nicht als Klartext anzeigen
  Icon passwordIcon =
      Icon(Icons.visibility); //Icon, das die Sichtbarkeit des Passworts toggelt
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: passwordObscure,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          //Icon des InputFields
          icon: Icon(
            widget.icon,
            color: ColorPalette.torea_bay.rgb,
          ),
          suffixIcon: IconButton(
            icon: passwordIcon,
            color: ColorPalette.endeavour.rgb,
            onPressed: () {
              setState(() => passwordObscure
                  ? {
                      passwordObscure =
                          false, //lässt die Eingabe im Klartext anzeigen
                      passwordIcon = Icon(Icons.visibility_off)
                    }
                  : {
                      passwordObscure =
                          true, //lässt die Eingabe verdeckt anzeigen
                      passwordIcon = Icon(Icons.visibility)
                    });
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
