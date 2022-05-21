import 'package:flutter/material.dart';

import 'demos/custom_painter.dart';
import 'demos/multi_child_layout.dart';
import 'demos/render_object.dart';
import 'demos/widget.dart';

void main() => runApp(
      const App(
        demo: Demo.widget,
      ),
    );

class App extends StatelessWidget {
  const App({super.key, required this.demo});

  final Demo demo;

  @override
  Widget build(BuildContext context) => MaterialApp(onGenerateRoute: (_) => demo.route);
}

enum Demo {
  widget(WidgetDemoPage()),
  multiChildLayout(MultiChildLayoutDemoPage()),
  customPainter(CustomPaintDemoPage()),
  renderObject(RenderObjectDemoPage());

  const Demo(this._page);

  final Widget _page;

  PageRoute<void> get route => MaterialPageRoute(builder: (_) => _page);
}
