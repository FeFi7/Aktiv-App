import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aktiv_app_flutter/Provider/body_provider.dart';
import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:aktiv_app_flutter/Provider/user_provider.dart';
import 'package:aktiv_app_flutter/Views/Home.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/veranstaltung/detail.dart';
import 'package:aktiv_app_flutter/components/rounded_button_dynamic.dart';
import 'package:aktiv_app_flutter/components/rounded_datepicker_button.dart';
import 'package:aktiv_app_flutter/components/rounded_input_email_field.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field_beschreibung.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field_numeric.dart';
import 'package:aktiv_app_flutter/components/rounded_input_field_suggestions.dart';
import 'package:aktiv_app_flutter/util/rest_api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../util/rest_api_service.dart';
import 'package:flutter_vant_kit/main.dart';

class VeranstaltungAnlegenView extends StatefulWidget {
  const VeranstaltungAnlegenView();
  @override
  _VeranstaltungAnlegenViewState createState() =>
      _VeranstaltungAnlegenViewState();
}

class _VeranstaltungAnlegenViewState extends State<VeranstaltungAnlegenView> {
  List<String> imageIds = [];
  var tcVisibility = false;
  File profileImage;
  final picker = ImagePicker();
  DateTime currentDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  bool institutionVorhanden = false;
  List<String> instituionen = [];

  var _controller = TextEditingController();

  //int id = 0;
  //
  List<String> images = [
    "https://img.yzcdn.cn/vant/leaf.jpg",
    "https://img.yzcdn.cn/vant/tree.jpg",
    "https://img.yzcdn.cn/vant/sand.jpg",
  ];
  String starttext = "Beginn";
  String endtext = "Ende";
  String titel = "Titel",
      beschreibung = "Beschreibung der Veranstaltung",
      email = "test@testmail.de",
      plz = "00000",
      adresse = "Adresse",
      start = "Start",
      ende = "Ende";
  Locale de = Locale('de', 'DE');
  List<String> tags = ['Musik', 'Sport', 'Freizeit'];
  List<String> selectedTags = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        locale: de,
        context: context,
        initialDate: currentDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365 * 10)));

    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
      await _selectTime(context);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay selectedTime = await showTimePicker(
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child),
      helpText: "Uhrzeit wählen",
      confirmText: "Ok",
      cancelText: "Abbrechen",
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (selectedTime != null && selectedTime != currentTime)
      setState(() {
        currentTime = selectedTime;
      });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(
      () {
        if (pickedFile != null) profileImage = File(pickedFile.path);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Visibility(
            visible: institutionVorhanden,
            child: new DropdownButton<String>(
              items: <String>['A', 'B', 'C', 'D'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
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
          RoundedInputFieldSuggestions(
            controller: _controller,
            hintText: 'Musik,Sport,Freizeit...',
            suggestions: tags,
            icon: Icons.tag,
            onChanged: (value) {
              if (value.endsWith(" ")) {
                selectedTags.add(value);
                _controller.clear();
              }
              if (value.endsWith(",")) {
                selectedTags.add(value);
                _controller.clear();
              }
              if (selectedTags.length != 0) {
                setState(() {
                  tcVisibility = true;
                });
              }
              ;
            },
            onSubmitted: (value) {
              selectedTags.add(value);

              if (selectedTags.length != 0) {
                setState(() {
                  tcVisibility = true;
                });
              }
              ;
            },
          ),
          Container(
            width: size.width * 0.5,
            child: Visibility(
                visible: tcVisibility,
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListView.builder(
                    itemCount: selectedTags.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          decoration: BoxDecoration(
                            color: ColorPalette.malibu.rgb,
                            borderRadius:
                                BorderRadius.all(Radius.circular(29.0)),
                          ),
                          padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
                          margin: EdgeInsets.all(5),
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${selectedTags[index]}'),
                              IconButton(
                                  icon: Icon(Icons.delete,
                                      color: ColorPalette.torea_bay.rgb),
                                  onPressed: () {
                                    setState(() {
                                      selectedTags.removeAt(index);
                                    });
                                  })
                            ],
                          ));
                    },
                    shrinkWrap: true,
                  ),
                )),
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
          Container(
            margin: EdgeInsets.fromLTRB(size.width * 0.1, 10, 0, 15),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: RoundedButtonDynamic(
                    width: size.width * 0.5,
                    text: 'Bilder',
                    icon: Icons.camera_alt,
                    color: ColorPalette.malibu.rgb,
                    textColor: Colors.black54,
                    press: () async {
                      await getImage();
                      Response resp =
                          await attemptFileUpload('Bild1', profileImage);
                      print(resp.body);
                      int id = 0;
                      if (resp.statusCode == 200) {
                        var parsedJson = json.decode(resp.body);
                        id = parsedJson['id'];
                        imageIds.add(id.toString());
                        // toastmsg = "Neue Veranstaltung angelegt";
                      } else {
                        var parsedJson = json.decode(resp.body);
                        var error = parsedJson['error'];
                        // toastmsg = error;
                      }
                    })),
          ),
          ImageWall(
            images: images,
            onChange: (images) {},
            onUpload: (files)async {},
          ),
          Container(
            margin: EdgeInsets.fromLTRB(size.width * 0.1, 10, 0, 15),
            child: Align(
                alignment: Alignment.bottomRight,
                child: RoundedButtonDynamic(
                    width: size.width * 0.4,
                    icon: Icons.save,
                    text: 'Speichern',
                    color: ColorPalette.orange.rgb,
                    textColor: Colors.white,
                    press: () async {
                      Provider.of<UserProvider>(context, listen: false)
                          .checkDataCompletion();
                      if (Provider.of<UserProvider>(context, listen: false)
                          .getDatenVollstaendig) {
                        await Provider.of<EventProvider>(context, listen: false)
                            .createEvent(titel, beschreibung, email, start,
                                ende, adresse)
                            .then((event) => {
                                  Provider.of<BodyProvider>(context,
                                          listen: false)
                                      .setBody(
                                          VeranstaltungDetailView(event.id))
                                  // Provider.of<AppBarTitleProvider>(context, listen: false)
                                  //     .setTitle('Übersicht');
                                });
                      }
                    })),
          )
        ],
      ),
    );
  }

  errorToast(String errorMessage) {
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: ColorPalette.orange.rgb,
      textColor: ColorPalette.white.rgb,
    );
    FocusManager.instance.primaryFocus.unfocus();
  }
}
