import 'package:flutter/cupertino.dart';

Future<T?> defaultDialog<T>({
  required BuildContext context,
  required String title,
  TextStyle? titleStyle,
  EdgeInsets? titlePadding,
  Widget? content,
  Widget? confirm,
  Widget? cancel,
}) {
  return showCupertinoDialog<T?>(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: titlePadding ?? EdgeInsets.zero,
              child: Text(title, style: titleStyle),
            ),
            const SizedBox(height: 20),
            if (content != null) ...[
              content,
              const SizedBox(height: 20),
            ],
            if (cancel != null || confirm != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  cancel ?? const SizedBox(),
                  confirm ?? const SizedBox(),
                ],
              ),
          ],
        ),
      );
    },
  );
}
