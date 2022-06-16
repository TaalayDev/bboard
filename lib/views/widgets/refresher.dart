import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Refresher extends StatefulWidget {
  const Refresher({
    Key? key,
    required this.child,
    this.header,
    this.controller,
    this.onRefresh,
    this.onLoading,
  }) : super(key: key);

  final Widget child;
  final Widget? header;
  final RefreshController? controller;
  final Function(RefreshController controller)? onRefresh;
  final Function(RefreshController controller)? onLoading;

  @override
  State<Refresher> createState() => _RefresherState();
}

class _RefresherState extends State<Refresher> {
  late final RefreshController controller;

  @override
  void initState() {
    controller = widget.controller ?? RefreshController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      child: widget.child,
      header: widget.header ?? BezierCircleHeader(),
      onRefresh: () => widget.onRefresh?.call(controller),
      onLoading: () => widget.onLoading?.call(controller),
    );
  }
}
