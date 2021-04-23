import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class CardDropDown extends StatelessWidget {
  final List<Widget> headerChildren;
  final List<Widget> bodyChildren;
  const CardDropDown({Key key, this.headerChildren, this.bodyChildren})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpandableNotifier(
        initialExpanded: false,
        child: Column(
          children: <Widget>[
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
