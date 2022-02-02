import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/theme.dart';

import 'app_expandable.dart';

class StyledAppDropDown<T> extends StatefulWidget {
  final List<T> list;
  final String? hintText;
  final String? title;
  final String? label;
  final T? value;
  final String Function(dynamic val) displayItem;
  final Function(dynamic item)? onChanged;

  const StyledAppDropDown({
    Key? key,
    required this.list,
    required this.displayItem,
    this.hintText,
    this.title,
    this.label,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  _StyledAppDropDownState<T> createState() => _StyledAppDropDownState<T>();
}

class _StyledAppDropDownState<T> extends State<StyledAppDropDown<T>>
    with AutomaticKeepAliveClientMixin {
  late final AnimateIconController _animateIconController;
  bool _menuOpened = false;
  T? _selectedItem;

  @override
  void initState() {
    _animateIconController = AnimateIconController();
    _selectedItem = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StyledAppDropDown<T> oldWidget) {
    if (widget.value != oldWidget.value)
      setState(() {
        _selectedItem = widget.value;
      });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        InkWell(
          borderRadius: _menuOpened
              ? const BorderRadius.only(
                  topLeft: Radius.circular(6.0),
                  topRight: Radius.circular(6.0),
                )
              : BorderRadius.circular(6.0),
          onTap: () {
            _openCloseMenu();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5),
            decoration: BoxDecoration(
              color: Get.theme.greyWeak,
              borderRadius: _menuOpened
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(6.0),
                      topRight: Radius.circular(6.0),
                    )
                  : BorderRadius.circular(6.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 18),
              title: Text(
                _selectedItem != null
                    ? widget.displayItem(_selectedItem)
                    : widget.label ?? widget.hintText ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: Get.theme.greyStrong.withOpacity(
                      _selectedItem != null || widget.label != null
                          ? 1.0
                          : 0.5),
                ),
              ),
              trailing: AnimateIcons(
                startIcon: Icons.keyboard_arrow_down,
                endIcon: Icons.keyboard_arrow_up,
                endIconColor: Get.theme.grey,
                startIconColor: Get.theme.grey,
                duration: const Duration(milliseconds: 500),
                onEndIconPress: () {
                  _openCloseMenu();
                  return true;
                },
                onStartIconPress: () {
                  _openCloseMenu();
                  return true;
                },
                controller: _animateIconController,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Get.theme.greyWeak,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(6.0),
              bottomRight: Radius.circular(6.0),
            ),
          ),
          child: AppExpandable(
            expand: _menuOpened,
            maxHeight: 250,
            child: Column(
              children: [
                const Divider(height: 0, color: Colors.black87),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: widget.list.asMap().entries.map(
                      (e) {
                        final _textColor =
                            Get.theme.greyStrong.withOpacity(0.5);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedItem = e.value;
                            });
                            widget.onChanged?.call(e.value);
                            _openCloseMenu();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.displayItem(e.value),
                                  style: TextStyle(
                                    color: _textColor,
                                    fontSize: 16,
                                  ),
                                ),
                                _radio(e.value),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _radio(value) {
    final greyColor = Get.theme.grey.withOpacity(0.5);
    return Container(
      height: 18,
      width: 18,
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        border: Border.all(color: greyColor),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          color: value == _selectedItem ? Get.theme.primary : greyColor,
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  _openCloseMenu() => setState(() {
        _menuOpened = !_menuOpened;
        _menuOpened
            ? _animateIconController.animateToEnd()
            : _animateIconController.animateToStart();
      });

  @override
  bool get wantKeepAlive => true;
}
