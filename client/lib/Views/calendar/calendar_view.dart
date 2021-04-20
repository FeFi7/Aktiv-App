import 'dart:developer';

import 'package:aktiv_app_flutter/Models/veranstaltung.dart';
import 'package:aktiv_app_flutter/Provider/event_provider.dart';

import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';
import 'package:aktiv_app_flutter/util/rest_api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView();

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

// TODO: Namen der Monate auf Deutsch ändern
class _CalendarViewState extends State<CalendarView> {
  // Map<DateTime, List<Veranstaltung>> _groupedEvents = {
  //   DateTime.now(): [
  //     Veranstaltung.create('titel', 'beschreibung', 'kontakt', 'ortBeschr',
  //         DateTime.now(), DateTime.now(), 0, 0)
  //   ]
  // };

  //late final
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

    // for (var event in Provider.of<EventProvider>(context, listen: false)
    //     .getLoadedEvents()) {
    //   DateTime date = DateTime.utc(
    //       event.beginnTs.year, event.beginnTs.month + futureMonthsLoaded, event.beginnTs.day);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          child: ToggleButtons(
            children: [
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Allgemein')),
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Persönlich')),
            ],
            isSelected: isSelected,
            onPressed: (int index) async {
              setState(() {
                // TODO: Persnlicher Kalender soll nur ausgeführt werden können, wenn man registrierter user ist

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
                // 
                _selectedEvents.value = [];
                        
                
                // List<Veranstaltung> events;
                // Provider.of<EventProvider>(context, listen: false)
                //     .loadAllEvents();

                // log(events.length.toString());

                //
              });
            },
            borderRadius: BorderRadius.circular(30),
            borderWidth: 1,
            selectedColor: ColorPalette.white.rgb,
            fillColor: ColorPalette.endeavour.rgb,
            disabledBorderColor: ColorPalette.french_pass.rgb,
          ),
        ),
        Container(
            padding: const EdgeInsets.all(10.0),
            child: TableCalendar(
              firstDay: DateTime.now(),
              // firstDay: DateTime.utc(200),
              focusedDay: _focusedDay,
              lastDay: DateTime(9999),
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
                return isSelected[0] ? Provider.of<EventProvider>(context, listen: false)
                    .getLoadedEventsOfDay(day) : Provider.of<EventProvider>(context, listen: false)
                    .getLikedEventsOfDay(day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;

                    _selectedEvents.value =
                        isSelected[0] ? Provider.of<EventProvider>(context, listen: false)
                    .getLoadedEventsOfDay(_selectedDay) : Provider.of<EventProvider>(context, listen: false)
                    .getLikedEventsOfDay(_selectedDay);
                    log("menge gelandener evnets: " +
                        Provider.of<EventProvider>(context, listen: false)
                            .getLoadedEvents()
                            .length
                            .toString());
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
                
                Provider.of<EventProvider>(context, listen: false)
                    .loadEventsOfMonth(DateTime(DateTime.now().year,
                        DateTime.now().month  + futureMonthsLoaded, DateTime.now().day));

                /// TODO: Erkennen in welhc richtung gescrollt wird => aktuell laden auch seiten wenn man nach links wischt
              },
            )),
        Expanded(
            child: ValueListenableBuilder<List<Veranstaltung>>(
          valueListenable: _selectedEvents,
          builder: (context, value, _) {
            return value != null && value.length > 0
                ? ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return EventPreviewBox(
                          value[index].id,
                          value[index].titel,
                          value[index].beschreibung,
                          value[index].titel,
                          false);
                    },
                  )
                : Container(child: Text("Keine Veranstaltung an diesem Tag"));
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
