import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';

class CustomSelect<T> extends StatelessWidget {
  const CustomSelect({
    Key? key,
    required this.list,
    required this.displayItem,
    required this.title,
    this.valueItem,
    this.hintText,
    this.label,
    this.value,
    this.onChanged,
    this.multiple,
    this.modalType,
  }) : super(key: key);

  final List<T> list;
  final String? hintText;
  final String title;
  final String? label;
  final dynamic value;
  final String Function(T val) displayItem;
  final dynamic Function(T val)? valueItem;
  final Function(dynamic item)? onChanged;
  final bool? multiple;
  final S2ModalType? modalType;

  @override
  Widget build(BuildContext context) {
    late Widget widget;
    if (multiple ?? false) {
      return SmartSelect.multiple(
        title: title,
        modalTitle: title,
        placeholder: hintText ?? '',
        modalType: modalType ?? S2ModalType.bottomSheet,
        value: value,
        onChange: (state) {
          onChanged?.call(state.value);
        },
        choiceItems: list
            .map<S2Choice>((e) => S2Choice(
                  value: valueItem?.call(e) ?? e,
                  title: displayItem(e),
                ))
            .toList(),
      );
    }

    return SmartSelect.single(
      title: title,
      placeholder: hintText ?? '',
      value: value,
      modalType: modalType ?? S2ModalType.bottomSheet,
      /*
      tileBuilder: (context, state) {
        state.showModal();
      },
      */
      modalTitle: title,
      onChange: (state) {
        onChanged?.call(state.value);
      },
      choiceItems: list
          .map<S2Choice>((e) => S2Choice(
                value: valueItem?.call(e) ?? e,
                title: displayItem(e),
              ))
          .toList(),
    );
  }
}
