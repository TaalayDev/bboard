import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';

class AddCommentScreen extends StatelessWidget {
  const AddCommentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Добавить комментарий',
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Отправить'),
          ),
        ],
      ),
    );
  }
}
