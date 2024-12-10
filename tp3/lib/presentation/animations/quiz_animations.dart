import 'package:flutter/material.dart';

class QuizAnimation {
  static Widget fadeIn(
      Widget child, {
        Duration duration = const Duration(seconds: 1),
        Curve curve = Curves.easeIn,
      }) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  static Widget scaleUp(
      Widget child, {
        Duration duration = const Duration(seconds: 1),
        Curve curve = Curves.easeInOut,
      }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.5, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, double scale, _) {
        return Transform.scale(scale: scale, child: child);
      },
    );
  }
}
