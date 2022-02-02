import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Function(String value)? onChanged;

  const PasswordField({
    Key? key,
    this.hintText,
    this.errorText,
    this.controller,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            TextFormField(
              obscureText: obscure,
              controller: widget.controller,
              validator: widget.validator,
              decoration: InputDecoration(
                hintText: widget.hintText,
              ),
              onChanged: widget.onChanged,
            ),
            Positioned(
              right: 10,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                icon: Icon(
                  obscure
                      ? Icons.remove_red_eye_outlined
                      : Icons.remove_red_eye,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                color: Colors.redAccent.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
