import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class CardDropDownImage extends StatelessWidget {
  //final BoxDecoration decoration;
  final List<Widget> decoration;
  final List<Widget> headerChildren;
  final List<Widget> bodyChildren;
  const CardDropDownImage(
      {Key key, this.decoration, this.headerChildren, this.bodyChildren})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpandableNotifier(
        initialExpanded: false,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100.0,
              child: Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: decoration),
              ),
            ),
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: headerChildren,
                  ),
                ),
                collapsed: SizedBox(height: 2.0),
                expanded: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: bodyChildren,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
