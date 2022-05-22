import 'package:flutter/widgets.dart';

extension RenderBoxRectExtension<T extends State> on GlobalKey<T> {
  Rect get rect {
    final renderBox = currentContext!.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero) & renderBox.size;
  }
}

extension ShiftExtension on Offset {
  Offset shift(double delta) => translate(delta, delta);
}

// https://stackoverflow.com/a/55088673/8236404
double Function(double input) interpolate({
  double inputMin = 0,
  double inputMax = 1,
  double outputMin = 0,
  double outputMax = 1,
}) {
  assert(inputMin != inputMax || outputMin != outputMax);

  final diff = (outputMax - outputMin) / (inputMax - inputMin);
  return (input) => ((input - inputMin) * diff) + outputMin;
}
