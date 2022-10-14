import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

enum PanningAxis { verticalAxis, horizontalAxis }

enum PointerType { tick, circle }

/// A Button which can be turned up or down to choose a value.
/// Somewhat like a circular slider
class PanButton extends StatefulWidget {
  final double initialValue;

  /// The minimum value handled by the button
  final double minValue;

  /// The maximum value handled by the button
  final double maxValue;

  final double size;

  /// The sensitivity of the button
  ///
  /// More it's close to 0, more the button is hard to turn
  final double sensitivity;

  /// The gap between the circle and the tics
  final double outerGap;

  /// The gap between the indicator and the circle
  final double innerGap;

  final double? tickSize;
  final double? pointerTickSize;

  /// The movement axis used to turn the button
  ///
  /// if it's `PanningAxis.verticalAxis` hold and move up to down,
  /// or down to up should turn the button
  /// if it's `PanningAxis.horizontalAxis` hold and move left to right.
  /// or right to left should turn the button
  final PanningAxis panningAxis;

  /// The button indicator shape used
  ///
  /// if it's `PointerType.tick` the indicator will be represented by a line
  /// if it's `PointerType.circle` the indicator will be represented by a circle
  final PointerType pointerType;

  final Color? tickColor;

  /// The button inner circle stroke color
  ///
  /// it can be set to `Colors.transparent` if you don't want to display it
  final Color circleStrokeColor;

  /// The button inner circle fill color
  final Color circleBackgroundColor;

  /// The button indicator color
  final Color pointerColor;

  /// The number of ticks displayed around the circle
  final int ticksCount;

  /// The inner padding of the widget
  ///
  final double? innerOffset;

  /// Should return the tick size given the [tickIndex] and the [value]
  /// of this tick
  final double Function(int tickIndex, double value)? getTickSize;

  /// Should return the tick color given the [tickIndex] and the [value]
  /// of this tick
  final Color Function(int tickIndex, double value)? getTickColor;

  /// Called with the new button's [value] when it change (when the user turn the button)
  final void Function(double value) valueChanged;

  /// Called when the user turn the button, with some nerd stuff
  final void Function(
    double startPanX,
    double startPanY,
    double curPanX,
    double curPanY,
    double delta,
  )? showMeNerdsStuff;

  const PanButton({
    super.key,
    this.initialValue = 0,
    required this.minValue,
    required this.maxValue,
    this.size = 100,
    this.sensitivity = 0.01,
    this.outerGap = 10,
    this.innerGap = 10,
    this.tickColor = Colors.black,
    this.circleBackgroundColor = Colors.transparent,
    this.circleStrokeColor = Colors.black,
    this.pointerColor = Colors.black,
    this.tickSize,
    this.pointerTickSize,
    this.getTickColor,
    this.getTickSize,
    this.pointerType = PointerType.tick,
    required this.valueChanged,
    this.showMeNerdsStuff,
    this.panningAxis = PanningAxis.verticalAxis,
    this.ticksCount = 4,
    this.innerOffset,
  });

  @override
  State<PanButton> createState() => _PanButtonState();
}

class _PanButtonState extends State<PanButton> {
  double _currentValue = 0;

  double _panStartX = -1, _panStartY = -1;
  double _panValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  void _onPanStart(DragStartDetails details) {
    // register the current state so we can
    // compute relative data
    _panStartX = details.globalPosition.dx;
    _panStartY = details.globalPosition.dy;
    _panValue = _currentValue;
  }

  void _onPanEnd(_) {
    _panStartX = -1;
    _panStartY = -1;
  }

  void _onPanMove(DragUpdateDetails details) {
    double panCurX = details.globalPosition.dx;
    double panCurY = details.globalPosition.dy;
    // compute the good offset
    double delta = widget.panningAxis == PanningAxis.horizontalAxis
        ? panCurX - _panStartX
        : panCurY - _panStartY;

    // clip the value and ajust with the sensitivity
    double val = min(
        max(_panValue + delta * widget.sensitivity, widget.minValue),
        widget.maxValue);
    setState(() {
      _currentValue = val;
    });
    widget.valueChanged(val); // notify the change
    if (widget.showMeNerdsStuff != null) {
      // feed the nerd ones
      widget.showMeNerdsStuff!(_panStartX, _panStartY, panCurX, panCurY, delta);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: GestureDetector(
          onPanStart: _onPanStart,
          onPanEnd: _onPanEnd,
          onPanUpdate: _onPanMove,
          child: CustomPaint(
            painter: PanButtonPainter(
              value: _currentValue,
              tickSize: widget.tickSize,
              ticksCount: widget.ticksCount,
              minValue: widget.minValue,
              maxValue: widget.maxValue,
              outerGap: widget.outerGap,
              innerGap: widget.innerGap,
              pointerType: widget.pointerType,
              pointerColor: widget.pointerColor,
              tickColor: widget.tickColor,
              getTickColor: widget.getTickColor,
              getTickSize: widget.getTickSize,
              pointerTickSize: widget.pointerTickSize,
              circleStrokeColor: widget.circleStrokeColor,
              circleBackgroundColor: widget.circleBackgroundColor,
              innerOffset: widget.innerOffset,
            ),
          )),
    );
  }
}

class PanButtonPainter extends CustomPainter {
  double value;
  double? tickSize;
  double? pointerTickSize;
  int ticksCount;
  double minValue;
  double maxValue;
  double outerGap;
  double innerGap;
  PointerType pointerType;
  Color pointerColor;
  Color circleBackgroundColor;
  Color circleStrokeColor;
  Color? tickColor;
  double? innerOffset;
  final Color Function(int tickIndex, double value)? getTickColor;
  final double Function(int tickIndex, double value)? getTickSize;

  PanButtonPainter({
    required this.value,
    this.tickSize,
    required this.ticksCount,
    required this.minValue,
    required this.maxValue,
    required this.outerGap,
    required this.innerGap,
    required this.pointerType,
    required this.pointerColor,
    required this.tickColor,
    required this.circleStrokeColor,
    required this.circleBackgroundColor,
    required this.innerOffset,
    this.pointerTickSize,
    this.getTickColor,
    this.getTickSize,
  });

  void _drawTicks(Canvas canvas, Size size,
      {required int nbTicks,
      required double fullRadius,
      required double tickSize,
      required double cx,
      required double cy}) {
    for (int i = 0; i < nbTicks; ++i) {
      double l = i / (nbTicks - 1);
      // linear interpolation to find the corresponding value
      double value = minValue * (1 - l) + maxValue * l;
      double size;
      if (getTickSize != null) {
        // the user callback function is called to get the custom tick size
        size = getTickSize!(i, value);
      } else {
        size = tickSize;
      }
      double r1 = fullRadius - size;
      double r2 = fullRadius;
      double theta = 2 * pi * i / nbTicks;
      double x1Tick = cx + r1 * cos(theta);
      double y1Tick = cy - r1 * sin(theta);
      double x2Tick = cx + r2 * cos(theta);
      double y2Tick = cy - r2 * sin(theta);
      Color color;
      if (getTickColor != null) {
        // the user callback is called to get the custom tick color
        color = getTickColor!(i, value);
      } else {
        color = tickColor!;
      }
      canvas.drawLine(
          Offset(x1Tick, y1Tick),
          Offset(x2Tick, y2Tick),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = color
            ..strokeWidth = 1);
    }
  }

  //void _drawIndicatorTick() {}

  @override
  void paint(Canvas canvas, Size size) {
    double fullRadius = innerOffset == null
        ? min(size.width, size.height) / 3
        : min(size.width, size.height) / 2 - innerOffset!;
    tickSize ??= fullRadius / 10;
    int nbTicks = ticksCount;
    double cx = size.width / 2;
    double cy = size.height / 2;

    double gap1 = outerGap;
    double gap2 = innerGap;

    // draw outer ticks
    _drawTicks(canvas, size,
        fullRadius: fullRadius,
        nbTicks: nbTicks,
        tickSize: tickSize!,
        cx: cx,
        cy: cy);

    // draw the inner circle
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        fullRadius - tickSize! - gap1,
        Paint()
          ..style = PaintingStyle.fill
          ..color = circleBackgroundColor);

    double r1 = fullRadius - tickSize! - gap1 - gap2;
    double r2 =
        fullRadius - tickSize! - gap1 - gap2 - (pointerTickSize ?? tickSize!);
    double lambda = (value - minValue) / (maxValue - minValue);
    // linear interpolation again
    // to find the good angle based on the current value
    double theta = 2 * pi * lambda;
    double x1Tick = cx + r1 * cos(theta);
    double y1Tick = cy + r1 * sin(theta);

    // draw the good indicator
    if (pointerType == PointerType.tick) {
      double x2Tick = cx + r2 * cos(theta);
      double y2Tick = cy + r2 * sin(theta);
      canvas.drawLine(
          Offset(x1Tick, y1Tick),
          Offset(x2Tick, y2Tick),
          Paint()
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke
            ..color = pointerColor);
    } else {
      canvas.drawCircle(
          Offset(x1Tick, y1Tick),
          pointerTickSize! / 2,
          Paint()
            ..strokeWidth = 1
            ..color = pointerColor);
    }

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        fullRadius - tickSize! - gap1,
        Paint()
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke
          ..color = circleStrokeColor);
  }

  @override

  /// Always repaint it since it's a dynamic object
  bool shouldRepaint(PanButtonPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(PanButtonPainter oldDelegate) => false;
}
