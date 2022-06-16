import 'package:flutter/material.dart';

abstract class StateWidget extends StatelessWidget {
  StateWidget({Key? key}) : super(key: key);

  var _initialized = false;

  void initState();

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      initState();
      _initialized = true;
    }

    throw Error();
  }
}
