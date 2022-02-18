import 'package:flutter/material.dart';

class FormBuilderController {
  Map<String, dynamic>? values;

  late final Function(String key, dynamic value) setValue;
  late final T? Function<T>(String key) getValue;
  late final Function(String key, dynamic value) seError;
  late final T? Function<T>(String key) getError;
  late final Map<String, dynamic> Function() getValues;

  FormBuilderController({
    this.values,
  });
}

class FormBuilder extends StatefulWidget {
  const FormBuilder({
    Key? key,
    required this.builder,
    required this.controller,
  }) : super(key: key);

  final Widget Function(BuildContext context) builder;
  final FormBuilderController controller;

  @override
  State<FormBuilder> createState() => _FormBuilderState();
}

class _FormBuilderState extends State<FormBuilder> {
  Map<String, dynamic> values = {};
  Map<String, dynamic> errors = {};

  @override
  void initState() {
    widget.controller.getValue = getValue;
    widget.controller.setValue = setValue;
    widget.controller.getError = getError;
    widget.controller.seError = setError;
    widget.controller.getValues = () => values;
    values = widget.controller.values ?? {};
    super.initState();
  }

  void setValue(String key, dynamic value) {
    values[key] = value;
    setState(() {});
  }

  T? getValue<T>(String key) {
    return values[key] as T;
  }

  void setError(String key, dynamic value) {
    errors[key] = value;
    setState(() {});
  }

  T? getError<T>(String key) {
    return errors[key] as T;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
