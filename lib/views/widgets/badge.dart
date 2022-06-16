import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final double top;
  final double right;
  final Widget child; // our badge widget will wrap this child widget
  final String? value; // what displays inside the badge
  final Color color; // the  background color of the badge - default is red

  const BadgeWidget({
    Key? key,
    required this.child,
    this.value,
    this.color = Colors.red,
    required this.top,
    required this.right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: double.infinity,
          child: child,
        ),
        if (value != null)
          Positioned(
            right: right,
            top: top,
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: color,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                value!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          )
      ],
    );
  }
}
