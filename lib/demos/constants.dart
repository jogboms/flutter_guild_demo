import 'package:flutter/material.dart';

class Constants {
  static const size = Size(720, 120);
  static final knobDimension = size.height;
  static final knobRadius = knobDimension / 2;
  static final knobToTrackPadding = knobDimension * .15;
  static final knobTrackSize = Size(size.width - knobToTrackPadding * 2, size.height - knobToTrackPadding * 2);
  static const knobBackgroundColor = Colors.white;
  static const knobElevation = 8.0;
  static final borderRadius = BorderRadius.circular(size.height / 2);
  static const gradientColors = [Colors.blueAccent, Colors.purpleAccent];
  static const gradient = LinearGradient(colors: gradientColors);
}
