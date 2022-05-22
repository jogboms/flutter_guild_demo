import 'package:flutter/material.dart';

import 'constants.dart';
import 'utils.dart';

class CustomPaintDemoPage extends StatelessWidget {
  const CustomPaintDemoPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: SliderWidget()));
}

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Constants.size,
      child: GestureDetector(
        onHorizontalDragStart: (details) => _onDragStart(details.localPosition),
        onHorizontalDragUpdate: (details) => _onDragUpdate(details.localPosition),
        child: CustomPaint(
          painter: SliderPainter(
            dragPosition: _dragPosition,
          ),
        ),
      ),
    );
  }

  double _dragPosition = 0.0;
  bool _canDragKnob = false;

  void _onDragStart(Offset position) {
    final knobRect = Offset(_dragPosition, 0) & Constants.knobSize;
    final knobLeftPosition = position.dx + Constants.knobRadius;
    _canDragKnob = knobLeftPosition >= knobRect.left && knobLeftPosition < knobRect.right;
  }

  void _onDragUpdate(Offset position) {
    if (!_canDragKnob) {
      return;
    }

    setState(() {
      _dragPosition = position.dx.clamp(0.0, Constants.size.width);
    });
  }
}

class SliderPainter extends CustomPainter {
  SliderPainter({required this.dragPosition});

  final double dragPosition;

  @override
  void paint(Canvas canvas, Size size) {
    final knobTrackRect = Offset.zero.shift(Constants.knobToTrackPadding) & Constants.knobTrackSize;
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

    final knobCenter = Offset(knobLeftPosition, size.height / 2);
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

  @override
  bool shouldRepaint(SliderPainter oldDelegate) => dragPosition != oldDelegate.dragPosition;
}
