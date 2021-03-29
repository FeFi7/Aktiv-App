import 'package:flutter/material.dart';

class EventPreviewBox extends StatefulWidget {
  const EventPreviewBox();

  @override
  _EventPreviewBoxState createState() => _EventPreviewBoxState();
}

class _EventPreviewBoxState extends State<EventPreviewBox> {
  int id;
  var titel;
  var description;
  var contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 175,
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF00487d),
          width: 3,
        ),
        borderRadius:
            BorderRadius.all(Radius.circular(10.0)), // rundung der border
        //color: const Color.fromRGBO(19, 12, 117, 1.0),
      ),
      child: Row(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(width: 100, height: 100),
          ),
          Column(
            children: <Widget>[
              Container(
                width: 210,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Veranstaltung!', style: TextStyle(fontSize: 20)),
                ),
              ),
              Container(
                  width: 230,
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'Hier kann Sinnvoler Text stehen, der die Veransatltung näher beschriebt, aber ich habe keine Ahnung was ich noch schrieben soll...',
                        style: TextStyle(fontSize: 12)),
                  ))
            ],
          ),
          Column(
            children: <Widget>[
              Align(
                heightFactor: 4,
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.favorite_border,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 32,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
