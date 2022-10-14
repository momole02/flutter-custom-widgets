import 'dart:math';

import 'package:flutter/material.dart';

/// An axis of the graph
class RadialAxis {
  final String id;

  /// The name displayed on the axis
  final String name;

  final double minValue;
  final double maxValue;
  final Color axisColor;
  final double lineWidth;
  final double xTextOffset;
  final double yTextOffset;

  // The text
  final TextStyle? legendStyle;

  RadialAxis(
      {this.name = "",
      required this.id,
      this.axisColor = Colors.black,
      this.legendStyle,
      this.minValue = 0,
      this.lineWidth = 1,
      this.xTextOffset = 0,
      this.yTextOffset = 0,
      this.maxValue = 100});
}

/// A data set which can be represented as a polygon on the graph
class SeriesData {
  final Color strokeColor;
  final Color fillColor;
  final double lineWidth;
  Map<String, double> data;
  SeriesData({
    this.strokeColor = Colors.black,
    this.fillColor = Colors.transparent,
    this.lineWidth = 1,
    required this.data,
  });
}

class RadialSeriesWidget extends StatefulWidget {
  final List<RadialAxis> axes;
  final List<SeriesData> series;

  const RadialSeriesWidget({
    super.key,
    required this.axes,
    required this.series,
  });

  @override
  State<RadialSeriesWidget> createState() => _RadialSeriesWidgetState();
}

class _RadialSeriesWidgetState extends State<RadialSeriesWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RadialSeriesPainter(axes: widget.axes, data: widget.series),
    );
  }
}

class RadialSeriesPainter extends CustomPainter {
  final List<RadialAxis> axes;
  final List<SeriesData> data;

  RadialSeriesPainter({
    required this.axes,
    required this.data,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double fullRadius = (1 / 3 + 1 / 20) * min(size.width, size.height);
    double cx = size.width / 2;
    double cy = size.height / 2;

    // draw the axes
    for (var i = 0; i < axes.length; i++) {
      double theta = 2 * pi * i / axes.length;
      // compute the point at the end of the axis
      double xAxis = cx + fullRadius * cos(theta);
      double yAxis = cy - fullRadius * sin(theta);
      // add the text offset to compute the
      double xText = xAxis + axes[i].xTextOffset;
      double yText = yAxis + axes[i].yTextOffset;
      TextSpan span = TextSpan(
          text: axes[i].name,
          style: axes[i].legendStyle ?? const TextStyle(color: Colors.black));
      TextPainter tp =
          TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(xText, yText));
      canvas.drawLine(
          Offset(cx, cy),
          Offset(xAxis, yAxis),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = axes[i].lineWidth
            ..color = axes[i].axisColor);
    }

    /// Generate the good polygon point on the good axis based on the index
    ///
    /// Since each index correspond to an axis
    generator(int index, SeriesData seriesData, int length) {
      String axisId = axes[index].id;
      double minValue = axes[index].minValue;
      double maxValue = axes[index].maxValue;
      double? value = seriesData.data[axisId];
      // linear interpolation to compute the right coordinates
      double t = (value! - minValue) / (maxValue - minValue);
      double x = cx + t * fullRadius * cos((2 * pi * index) / length);
      double y = cy - t * fullRadius * sin((2 * pi * index) / length);
      return Offset(x, y);
    }

    // draw the series
    for (var di = 0; di < data.length; ++di) {
      int length = data[di].data.length;
      // generate the points on each axis
      // for the current data set
      List<Offset> polygon =
          List.generate(length, (index) => generator(index, data[di], length));
      Path path = Path();
      path.addPolygon(polygon, true);
      canvas.drawPath(
          path,
          Paint()
            ..color = data[di].fillColor
            ..style = PaintingStyle.fill);
      canvas.drawPath(
          path,
          Paint()
            ..strokeWidth = data[di].lineWidth
            ..color = data[di].strokeColor
            ..style = PaintingStyle.stroke);
      // canvas.drawPoints(
      //     PointMode.polygon,
      //     polygon,
      //     Paint()
      //       ..color = data[di].strokeColor
      //       ..style = PaintingStyle.stroke);
    }
  }

  @override

  /// It's repainted since it's a dynamic widget
  bool shouldRepaint(RadialSeriesPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(RadialSeriesPainter oldDelegate) => false;
}
