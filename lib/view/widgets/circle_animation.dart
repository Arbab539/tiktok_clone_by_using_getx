import 'package:flutter/material.dart';

class CircleAnimation extends StatefulWidget {
  final Widget child;

  const CircleAnimation({Key? key, required this.child}) : super(key: key);

  @override
  State<CircleAnimation> createState() => _CircleAnimationState();
}

class _CircleAnimationState extends State<CircleAnimation> with SingleTickerProviderStateMixin {

  late AnimationController container;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    container = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 5000)
    );
    container.forward();
    container.repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    container.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0,end: 1.0,).animate(container),
      child: widget.child,

    );
  }
}
