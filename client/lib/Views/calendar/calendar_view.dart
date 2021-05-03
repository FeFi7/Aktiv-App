import 'dart:developer';

import 'package:aktiv_app_flutter/Models/veranstaltung.dart';
import 'package:aktiv_app_flutter/Provider/event_provider.dart';
import 'package:aktiv_app_flutter/Provider/user_provider.dart';

import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:aktiv_app_flutter/Models/role_permissions.dart';

class CalendarView extends StatefulWidget {
  const CalendarView();

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

// TODO: Namen der Monate auf Deutsch ändern
class _CalendarViewState extends State<CalendarView> {
  ValueNotifier<List<Veranstaltung>> _selectedEvents;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;

  final List<bool> isSelected = [true, false];

  int futureMonthsLoaded = 1;

  @override
  void initState() {
    super.initState();

    _selectedEvents = ValueNotifier([]);
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Column(
      children: [
        Stack(
          children: [
            Container(
                padding: const EdgeInsets.all(10.0),
                child: TableCalendar(
                  locale: 'de_DE',
                  firstDay: DateTime.now(),
                  // firstDay: DateTime.utc(200),
                  focusedDay: _focusedDay,
                  lastDay: DateTime.utc(now.year + 1, now.month, now.day),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarFormat: _calendarFormat,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  calendarBuilders: calendarBuilder(),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  eventLoader: (day) {
                    return isSelected[0]
                        ? Provider.of<EventProvider>(context, listen: false)
                            .getLoadedEventsOfDay(day)
                        : Provider.of<EventProvider>(context, listen: false)
                            .getLoadedAndLikedEventsOfDay(day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;

                        _selectedEvents.value = isSelected[0]
                            ? Provider.of<EventProvider>(context, listen: false)
                                .getLoadedEventsOfDay(_selectedDay)
                            : Provider.of<EventProvider>(context, listen: false)
                                .getLoadedAndLikedEventsOfDay(_selectedDay);
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;

                    Provider.of<EventProvider>(context, listen: false)
                        .loadAllEventsUntil(DateTime(
                            DateTime.now().year,
                            DateTime.now().month +
                                futureMonthsLoaded++, //TODO: begrenzen
                            DateTime.now().day));

                    /// TODO: Erkennen in welhc richtung gescrollt wird => aktuell laden auch seiten wenn man nach links wischt
                  },
                )),
            Positioned(
              right: 45,
              top: 10,
              child: UserProvider.getUserRole().allowedToFavEvents
                  ? (Container(
                    height: 40,
                      margin: const EdgeInsets.all(10.0),
                      child: ToggleButtons(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('Allgemein')),
                          Container(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('Persönlich')),
                        ],
                        isSelected: isSelected,
                        onPressed: (int index) async {
                          setState(() {
                            for (int buttonIndex = 0;
                                buttonIndex < isSelected.length;
                                buttonIndex++) {
                              if (buttonIndex == index) {
                                isSelected[buttonIndex] = true;
                              } else {
                                isSelected[buttonIndex] = false;
                              }
                            }

                            _selectedDay = null;
                            _selectedEvents.value = [];
                          });
                        },
                        borderRadius: BorderRadius.circular(40),
                        borderWidth: 1,
                        selectedColor: ColorPalette.white.rgb,
                        fillColor: ColorPalette.endeavour.rgb,
                        disabledBorderColor: ColorPalette.french_pass.rgb,
                      ),
                    ))
                  : Container(),

              /// Leerer Container, falls User nicht eingeloggt ist
            )
          ],
        ),
        Expanded(
            child: ValueListenableBuilder<List<Veranstaltung>>(
          valueListenable: _selectedEvents,
          builder: (context, value, _) {
            return value != null && value.length > 0
                ? ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return EventPreviewBox.load(
                          value[index], AdditiveFormat.HOLE_DATETIME);
                    },
                  )
                : Container(
                    child: Text(_selectedDay != null
                        ? "Keine Veranstaltungen eingetragen"
                        : "Für eine generauer Übersicht Tag auswählen"));
          },
        ))
      ],
    );
  }

  // Farbschema des Kalenders festlegen
  CalendarBuilders calendarBuilder() {
    return CalendarBuilders(
      selectedBuilder: (context, date, _) {
        return CalendarDay(date.day.toString(), ColorPalette.french_pass.rgb,
            ColorPalette.torea_bay.rgb);
      },
      todayBuilder: (context, date, _) {
        return CalendarDay(date.day.toString(), ColorPalette.dark_grey.rgb,
            ColorPalette.french_pass.rgb);
      },
      defaultBuilder: (context, date, _) {
        return CalendarDay(date.day.toString(), ColorPalette.endeavour.rgb);
      },
      outsideBuilder: (context, date, _) {
        return CalendarDay(date.day.toString(), ColorPalette.dark_grey.rgb);
      },
      disabledBuilder: (context, date, _) {
        return CalendarDay(date.day.toString(), ColorPalette.light_grey.rgb);
      },
      singleMarkerBuilder: (context, date, _) {
        return SingleMarkerDay(
            isSelected[1] ? ColorPalette.orange.rgb : ColorPalette.malibu.rgb);
      },
    );
  }
}

// ignore: must_be_immutable
class SingleMarkerDay extends StatelessWidget {
  Color backgroundColor;

  SingleMarkerDay(this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.all(2),
      decoration: new BoxDecoration(
          color: backgroundColor,
          borderRadius: new BorderRadius.circular(40.0)),
    );
  }
}

// ignore: must_be_immutable
class CalendarDay extends StatelessWidget {
  String content;
  Color backgroundColor;
  Color textColor;

  CalendarDay(this.content, this.textColor, [this.backgroundColor]);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: new BoxDecoration(
          color: backgroundColor,
          borderRadius: new BorderRadius.circular(40.0)),
      child: Center(
        child: Text(content,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
