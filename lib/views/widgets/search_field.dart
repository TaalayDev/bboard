import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../res/theme.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
    this.onChanged,
    this.onStopEditing,
    this.controller,
  }) : super(key: key);

  final Function(String value)? onChanged;
  final Function(String value)? onStopEditing;
  final TextEditingController? controller;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TextField(
        controller: widget.controller,
        onChanged: (value) {
          widget.onChanged?.call(value);
          if (_timer?.isActive ?? false) _timer?.cancel();
          _timer = Timer(const Duration(milliseconds: 800), () {
            widget.onStopEditing?.call(value);
          });
        },
        decoration: InputDecoration(
          fillColor: context.theme.onPrimary,
          filled: true,
          prefixIcon: const Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: Icon(Feather.search, size: 18),
          ),
          hintText: 'Я ищу...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
