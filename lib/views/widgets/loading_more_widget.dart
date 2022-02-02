import 'package:flutter/material.dart';

class LoadingMoreWidget extends StatelessWidget {
  const LoadingMoreWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator(),
        ),
        SizedBox(width: 20),
        Text('Загрузка...'),
      ],
    );
  }
}
