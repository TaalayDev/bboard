import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import '../../resources/theme.dart';

class CustomSearchBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomSearchBar({
    Key? key,
    this.backIcon,
    this.textController,
    this.onSearchPressed,
    this.onSearchTextChanged,
    this.onStopEditingSearchText,
  }) : super(key: key);

  final Widget? backIcon;
  final TextEditingController? textController;
  final Function()? onSearchPressed;
  final Function(String value)? onSearchTextChanged;
  final Function(String value)? onStopEditingSearchText;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 60,
      elevation: 0.0,
      leading: backIcon,
      titleSpacing: backIcon != null ? 0 : null,
      title: Hero(
        tag: 'search_bar_field',
        child: SizedBox(
          height: 40,
          child: _SearchField(
            controller: textController,
            onChanged: onSearchTextChanged,
            onStopEditing: onStopEditingSearchText,
          ),
        ),
      ),
      actions: [
        backIcon != null ? const SizedBox(width: 5) : const SizedBox(),
        Hero(
          tag: 'search_bar_button',
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: onSearchPressed,
              color: context.theme.onPrimary,
              icon: const Icon(Feather.search, size: 30),
            ),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchField extends StatefulWidget {
  const _SearchField({
    Key? key,
    this.onChanged,
    this.onStopEditing,
    this.controller,
  }) : super(key: key);

  final Function(String value)? onChanged;
  final Function(String value)? onStopEditing;
  final TextEditingController? controller;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
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
          fillColor: AppTheme.theme.onPrimaryColor,
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
