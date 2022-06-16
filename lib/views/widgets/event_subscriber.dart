import 'package:event/event.dart';
import 'package:flutter/material.dart';

class EventSubscriber<T extends EventArgs> extends StatefulWidget {
  const EventSubscriber({
    Key? key,
    required this.event,
    required this.builder,
    this.onEvent,
    this.rebuildOnEvent = true,
  }) : super(key: key);

  final Event<T> event;
  final void Function(BuildContext context, T? event)? onEvent;
  final Widget Function(BuildContext context, T? event) builder;
  final bool rebuildOnEvent;

  @override
  State<EventSubscriber> createState() => _EventSubscriberState<T>();
}

class _EventSubscriberState<T extends EventArgs>
    extends State<EventSubscriber<T>> {
  T? event;

  @override
  void initState() {
    // subscribe to events
    widget.event + _onEvent;
    super.initState();
  }

  @override
  void dispose() {
    // unsubscribe from events
    widget.event - _onEvent;
    super.dispose();
  }

  void _onEvent(T? event) {
    if (widget.onEvent != null) widget.onEvent?.call(context, event);
    if (widget.rebuildOnEvent) {
      setState(() {
        this.event = event;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, event);
  }
}
