import 'package:bboard/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class AddCommentPage extends StatelessWidget {
  const AddCommentPage({Key? key}) : super(key: key);

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
