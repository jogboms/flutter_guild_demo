import 'package:flutter/material.dart';

import 'constants.dart';
import 'utils.dart';

class WidgetDemoPage extends StatelessWidget {
  const WidgetDemoPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: SliderWidget()));
}

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  final GlobalKey _sliderKey = GlobalKey();
  final GlobalKey _knobKey = GlobalKey();
  final GlobalKey _knobTrackKey = GlobalKey();

  double _knobLeftPosition = 0.0;
  Color _knobColor = Constants.gradientColors.first;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      key: _sliderKey,
      size: Constants.size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            width: Constants.knobTrackSize.width,
            height: Constants.knobTrackSize.height,
            child: DecoratedBox(
              key: _knobTrackKey,
              decoration: BoxDecoration(
                gradient: Constants.gradient,
                borderRadius: Constants.borderRadius,
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: _knobLeftPosition,
            width: Constants.knobDimension,
            child: GestureDetector(
              key: _knobKey,
              onHorizontalDragStart: (_) => _onDragStart(),
              onHorizontalDragUpdate: (details) => _onDragUpdate(details.primaryDelta!),
              child: Material(
                shape: CircleBorder(
                  side: BorderSide(
                    color: Constants.knobBackgroundColor,
                    width: Constants.knobToTrackPadding,
                  ),
                ),
                shadowColor: Constants.knobShadowColor,
                color: _knobColor,
                elevation: Constants.knobElevation,
              ),
            ),
          )
        ],
      ),
    );
  }

  double _dragLeftPosition = 0.0;

  void _onDragStart() {
    _dragLeftPosition = _knobKey.rect.left;
  }

  void _onDragUpdate(double delta) {
    final sliderRect = _sliderKey.rect;
    final knobTrackRect = _knobTrackKey.rect;

    final lowerLimit = knobTrackRect.left - Constants.knobRadius;
    final upperLimit = knobTrackRect.right - Constants.knobRadius;
    final dragLeftPosition = (_dragLeftPosition + delta).clamp(
      lowerLimit,
      upperLimit,
    );
    if (_dragLeftPosition == dragLeftPosition) {
      return;
    }

    setState(() {
      _dragLeftPosition = dragLeftPosition;
      _knobLeftPosition = _dragLeftPosition - sliderRect.left;
      _knobColor = Color.lerp(
        Constants.gradientColors.first,
        Constants.gradientColors.last,
        interpolate(inputMin: lowerLimit, inputMax: upperLimit)(_dragLeftPosition),
      )!;
    });
  }
}
