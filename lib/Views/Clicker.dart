import 'package:aktiv_app_flutter/Provider/ClickerProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Clicker extends StatelessWidget {
  const Clicker({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
          ),
          Consumer<ClickerProvider>(builder: (context, value, child) {
            return Text(
              value.count.toString(),
              style: Theme.of(context).textTheme.headline4,
            );
          }),
        ]);
  }
}
