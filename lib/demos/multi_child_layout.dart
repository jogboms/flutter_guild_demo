import 'package:flutter/material.dart';

import 'constants.dart';
import 'utils.dart';

class MultiChildLayoutDemoPage extends StatelessWidget {
  const MultiChildLayoutDemoPage({super.key});

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
      child: CustomMultiChildLayout(
        delegate: SliderLayoutDelegate(
          knobLeftPosition: _knobLeftPosition,
        ),
        children: [
          LayoutId(
            id: SliderChildSlot.knobTrack,
            child: DecoratedBox(
              key: _knobTrackKey,
              decoration: BoxDecoration(
                gradient: Constants.gradient,
                borderRadius: Constants.borderRadius,
              ),
            ),
          ),
          LayoutId(
            id: SliderChildSlot.knob,
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
          ),
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

enum SliderChildSlot {
  knob,
  knobTrack,
}

class SliderLayoutDelegate extends MultiChildLayoutDelegate {
  SliderLayoutDelegate({required this.knobLeftPosition});

  final double knobLeftPosition;

  @override
  void performLayout(Size size) {
    layoutChild(
      SliderChildSlot.knobTrack,
      BoxConstraints.tight(Constants.knobTrackSize),
    );
    positionChild(
      SliderChildSlot.knobTrack,
      Offset.zero.shift(Constants.knobToTrackPadding),
    );

    layoutChild(
      SliderChildSlot.knob,
      BoxConstraints.tight(Constants.knobSize),
    );
    positionChild(
      SliderChildSlot.knob,
      Offset(knobLeftPosition, 0),
    );
  }

  @override
  bool shouldRelayout(SliderLayoutDelegate oldDelegate) => knobLeftPosition != oldDelegate.knobLeftPosition;
}
