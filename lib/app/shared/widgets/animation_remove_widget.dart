import 'package:flutter/material.dart';

class AnimationRemoveWidget extends StatelessWidget {
  final Animation<double> animation;
  final Widget widget;
  const AnimationRemoveWidget(
      {Key? key, required this.animation, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: Column(
        children: [widget, const SizedBox(height: 20)],
      ),
    );
  }
}
