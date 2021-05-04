import 'dart:async';
import 'dart:convert';
import 'dart:core';

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
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../util/rest_api_service.dart';

class VeranstaltungAnlegenView extends StatefulWidget {
  const VeranstaltungAnlegenView();
  @override
  _VeranstaltungAnlegenViewState createState() =>
      _VeranstaltungAnlegenViewState();
}

class _VeranstaltungAnlegenViewState extends State<VeranstaltungAnlegenView> {
  int istGenehmigt = 0;
  List<String> imageIds = [];
  Map<String, int> institutionen = Map<String, int>();

  String selectedInstitutition = 'Institution';
  var tcVisibility = true;
  File profileImage;
  final picker = ImagePicker();

  DateTime currentDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  bool institutionVorhanden = false;
  //List<dynamic> instituionen = [];
  String imageName;
  int imageId;
  var _controller = TextEditingController();

  final controllerTitel = TextEditingController();
  final controllerBeschreibung = TextEditingController();
  final controlleremail = TextEditingController();
  final controllerPlz = TextEditingController();
  final controllerAdresse = TextEditingController();

  int institutionsId = 0;
  //
  List<String> images = [];
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

  List<DropdownMenuItem<String>> items = [];

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
    //final pickedFile = await picker.getImage(source: ImageSource.gallery);
    final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
    if (pickedFile != null) {
      profileImage = File(pickedFile.files.single.path);
      print(profileImage);
      setState(
        () {
          if (pickedFile != null) {
            //profileImage = File(pickedFile.path);
            images.add(profileImage.path);
          }
        },
      );
    }
  }

  Future<Map<String, int>> awaitUserData() async {
    var response = await Provider.of<UserProvider>(context, listen: false)
        .getVerwalteteInstitutionen();

    //institutionen.add(response[0]['name']);
    institutionen.clear();
    institutionen['Privat'] = -1;
    List<dynamic> dynamicList = response.map((item) => (item['name'])).toList();
    List<String> namen = List<String>.from(dynamicList).toList();
    List<dynamic> dynamicList2 = response.map((item) => (item['id'])).toList();
    List<int> ids = List<int>.from(dynamicList2).toList();
    for (int i = 0; i < namen.length; i++) {
      institutionen[namen[i]] = ids[i];
    }

    //institutionen.add(parsedjson['name']);
    // Response allTags = await attemptGetTags();

    if (institutionen.keys.length > 1) {
      institutionVorhanden = true;
    }

    return institutionen;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<Map<String, int>>(
        future: awaitUserData(),
        builder: (context, snapshot) {
          {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }

            final events = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                    visible: institutionVorhanden,
                    child: new DropdownButton<dynamic>(
                      hint: Text(selectedInstitutition),
                      items: institutionen.keys.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedInstitutition = value;
                          institutionsId = institutionen[value];
                        });
                      },
                    ),
                  ),
                  RoundedInputField(
                    hintText: "Titel",
                    icon: Icons.title,
                    controller: controllerTitel,
                  ),
                  RoundedInputFieldBeschreibung(
                    hintText: 'Beschreibung der Veranstaltung',
                    icon: Icons.edit,
                    controller: controllerBeschreibung,
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
                        setState(() {});
                      }
                      if (value.endsWith(",")) {
                        selectedTags.add(value);
                        _controller.clear();
                        setState(() {});
                      }

                      ;
                    },
                    onSubmitted: (value) {
                      selectedTags.add(value);

                      if (selectedTags.length != 0) {
                        setState(() {});
                      }
                      ;
                    },
                  ),
                  Container(
                    width: size.width * 0.5,
                    child: Visibility(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                    controller: controlleremail,
                  ),
                  RoundedInputFieldNumeric(
                    hintText: "Postleitzahl",
                    controller: controllerPlz,
                    icon: Icons.home,
                  ),
                  RoundedInputField(
                    hintText: "Adresse",
                    icon: Icons.location_on_rounded,
                    controller: controllerAdresse,
                  ),
                  RoundedDatepickerButton(
                    text: starttext,
                    color: ColorPalette.malibu.rgb,
                    textColor: Colors.black54,
                    press: () async {
                       currentDate = DateTime.now();
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
                      currentDate = DateTime.now().add(Duration(days: 1));
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
                  Container(
                    margin: EdgeInsets.fromLTRB(size.width * 0.1, 10, 0, 15),
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: RoundedButtonDynamic(
                            width: size.width * 0.8,
                            text: 'Bilder',
                            icon: Icons.camera_alt,
                            color: ColorPalette.malibu.rgb,
                            textColor: Colors.black54,
                            press: () async {
                              await getImage();
                              if(profileImage != null){
                              Response resp = await attemptFileUpload(
                                  'Bild1', profileImage);
                              print(resp.body);
                              int id = 0;
                              if (resp.statusCode == 200) {
                                var parsedJson = json.decode(resp.body);
                                imageId = parsedJson['id'];
                                imageIds.add(imageId.toString());
                                // toastmsg = "Neue Veranstaltung angelegt";
                              } else {
                                var parsedJson = json.decode(resp.body);
                                var error = parsedJson['error'];
                                // toastmsg = error;
                              }
                              setState(() {});}
                            })),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(size.width * 0.1, 10, size.width * 0.1, 15),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: RoundedButtonDynamic(
                            width: size.width * 0.5,
                            icon: Icons.save,
                            text: 'Speichern',
                            color: ColorPalette.orange.rgb,
                            textColor: Colors.white,
                            press: () async {
                              if (institutionsId > 0) {
                                istGenehmigt = 1;
                              }

                              Provider.of<UserProvider>(context, listen: false)
                                  .checkDataCompletion();
                              if (Provider.of<UserProvider>(context,
                                      listen: false)
                                  .getDatenVollstaendig) {
                                await Provider.of<EventProvider>(context,
                                        listen: false)
                                    .createEvent(
                                        controllerTitel.text,
                                        controllerBeschreibung.text,
                                        controlleremail.text,
                                        start,
                                        ende,
                                        controllerAdresse.text,
                                        controllerPlz.text,
                                        institutionsId,
                                        istGenehmigt,
                                        imageIds,
                                        selectedTags)
                                    .then((event) => {
                                          Provider.of<BodyProvider>(context,
                                                  listen: false)
                                              .setBody(VeranstaltungDetailView(
                                                  event.id))
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
        });
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
