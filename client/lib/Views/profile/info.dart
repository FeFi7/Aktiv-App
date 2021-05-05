import 'package:aktiv_app_flutter/Provider/body_provider.dart';
import 'package:aktiv_app_flutter/Views/defaults/color_palette.dart';
import 'package:aktiv_app_flutter/Views/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Home.dart';

class InfoView extends StatefulWidget {
  InfoView({Key key}) : super(key: key);

  @override
  _InfoViewState createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50.0),
        Text(
          "Informationen",
          style: TextStyle(color: ColorPalette.endeavour.rgb, fontSize: 36.0),
        ),
        SizedBox(height: 30.0),
        Text(
          "Konzept & Idee: ",
          style: TextStyle(fontSize: 22.0),
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("Lebensqualität Burgrieden e.V.unterstützt durch: Bürgerstiftung Burgrieden\n\nBesonderer Dank an " +
              "die Projektgruppe von LQ e.V.:\n\nHarald Dammann\nIngeborg Pfaff\nRobert Mages\nSilvia Beitner\n\n" +
              "an Herrn Prof. Dr. Klaus Baer der Technischen Hochschule Ulm für die wissenschaftliche Unterstützung und vor allem an unsere Programmierer:\n\n" +
              "Viktor Dötzel\nFelix Filser\nFabian Bösel\nNiko Burkert\nMoritz Nentwig\nFlorian Kovacsik"),
        ),
        TextButton(
          onPressed: () {
            Provider.of<BodyProvider>(context, listen: false)
                .setBody(ProfileScreen());
            Provider.of<AppBarTitleProvider>(context, listen: false)
                .setTitle('Eigenes Profil');
          },
          child: Text("zurück"),
        ),
      ],
    );
  }
}
