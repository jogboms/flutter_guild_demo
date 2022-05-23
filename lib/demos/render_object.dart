import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:guild_demo/constants.dart';
import 'package:guild_demo/utils.dart';

class RenderObjectDemoPage extends StatelessWidget {
  const RenderObjectDemoPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: SliderWidget()));
}

class SliderWidget extends LeafRenderObjectWidget {
  const SliderWidget({super.key});

  @override
  RenderObject createRenderObject(BuildContext context) => SliderRenderObject();
}

class SliderRenderObject extends RenderBox {
  late final drag = HorizontalDragGestureRecognizer()
    ..onStart = _onDragStart
    ..onUpdate = _onDragUpdate;

  late Rect knobRect;

  double dragPosition = 0.0;
  bool canDragKnob = false;

  @override
  void performLayout() {
    size = Constants.size;
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      drag.addPointer(event);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    final knobTrackRect = offset.shift(Constants.knobToTrackPadding) & Constants.knobTrackSize;
    canvas.drawRRect(
      Constants.borderRadius.toRRect(knobTrackRect),
      Paint()..shader = Constants.gradient.createShader(knobTrackRect),
    );

    final lowerLimit = knobTrackRect.left;
    final upperLimit = knobTrackRect.right;

    final knobLeftPosition = dragPosition.clamp(lowerLimit, upperLimit);
    final knobColor = Color.lerp(
      Constants.gradientColors.first,
      Constants.gradientColors.last,
      interpolate(inputMin: lowerLimit, inputMax: upperLimit)(knobLeftPosition),
    )!;

    final knobCenter = Offset(knobLeftPosition, offset.dy + size.height / 2);
    knobRect = Rect.fromCircle(center: knobCenter, radius: Constants.knobRadius);

    canvas
      ..drawShadow(
        Path()..addOval(Rect.fromCircle(center: knobCenter, radius: Constants.knobRadius)),
        Constants.knobShadowColor,
        Constants.knobElevation,
        true,
      )
      ..drawCircle(
        knobCenter,
        Constants.knobRadius,
        Paint()..color = Constants.knobBackgroundColor,
      )
      ..drawCircle(
        knobCenter,
        Constants.knobRadius - Constants.knobToTrackPadding,
        Paint()..color = knobColor,
      );
  }

  void _onDragStart(DragStartDetails details) {
    canDragKnob = knobRect.contains(details.localPosition);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!canDragKnob) {
      return;
    }
    dragPosition += details.primaryDelta!;
    markNeedsPaint();
  }
}
