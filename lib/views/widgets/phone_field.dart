import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneField extends StatefulWidget {
  const PhoneField({
    Key? key,
    this.errorText,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  final String? errorText;
  final TextEditingController? controller;
  final Function(String value)? onChanged;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  final phoneFormatter = MaskTextInputFormatter(
    mask: '### ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  String value = '7';

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 13,
      controller: widget.controller,
      inputFormatters: [
        phoneFormatter,
      ],
      onChanged: (phone) {
        widget.onChanged?.call(value + phone);
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        // hintText: 'phone'.tr,
        errorText: widget.errorText,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 25, right: 5, bottom: 2),
          child: dropdown(),
        ),
        counterText: '',
      ),
    );
  }

  dropdown() {
    return SizedBox(
      width: value == '7'
          ? 40
          : value == '996'
              ? 58
              : null,
      child: PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: '7',
            onTap: () {},
            child: Text('+7'),
          ),
          PopupMenuItem(
            value: '996',
            onTap: () {},
            child: Text('+996'),
          ),
        ],
        onSelected: (item) {
          _selectItem(item);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('+$value'),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  _selectItem(item) {
    value = item;
    switch (value) {
      case '7':
        phoneFormatter.updateMask(mask: '### ### ## ##');
        break;
      case '996':
        phoneFormatter.updateMask(mask: '### ## ## ##');
        break;
    }
    setState(() {});
  }
}
