import 'package:flutter/material.dart';

class WantKeepAlive extends StatefulWidget {
  const WantKeepAlive({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<WantKeepAlive> createState() => _WantKeepAliveState();
}

class _WantKeepAliveState extends State<WantKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
