import 'package:flutter/material.dart';

class AnimatedListItem extends StatefulWidget {
  const AnimatedListItem({
    Key? key,
    required this.index,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  final int index;
  final Widget child;
  final Duration duration;

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        setState(() {
          _animate = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: widget.duration,
      padding: _animate
          ? const EdgeInsets.symmetric(vertical: 4.0)
          : EdgeInsets.zero,
      child: AnimatedOpacity(
        duration: widget.duration,
        opacity: _animate ? 1 : 0,
        curve: Curves.easeInOutQuart,
        child: widget.child,
      ),
    );
  }
}
