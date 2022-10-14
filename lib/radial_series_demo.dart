import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:math_effects/custom-widgets/pan_button.dart';
import 'package:math_effects/custom-widgets/radial_series_widget.dart';

class RadialSeriesDemo extends StatefulWidget {
  const RadialSeriesDemo({super.key});

  @override
  State<RadialSeriesDemo> createState() => _RadialSeriesDemoState();
}

enum EditionMode { data1, data2 }

class _RadialSeriesDemoState extends State<RadialSeriesDemo> {
  EditionMode mode = EditionMode.data1;
  Map<EditionMode, Color> colorMap = {
    EditionMode.data1: Colors.red,
    EditionMode.data2: Colors.green
  };
  SeriesData s1 = SeriesData(
      data: {
        'balance': 0,
        'speed': 0,
        'accuracy': 0,
        'skill': 0,
        'jump': 0,
      },
      lineWidth: 2,
      fillColor: Colors.pink.withOpacity(0.3),
      strokeColor: Colors.red.shade800);

  SeriesData s2 = SeriesData(
      data: {
        'balance': 0,
        'speed': 0,
        'accuracy': 0,
        'skill': 0,
        'jump': 0,
      },
      lineWidth: 1.5,
      fillColor: Colors.green.withOpacity(0.3),
      strokeColor: Colors.green.shade800);

  getSeriesValue(String key) {
    return mode == EditionMode.data1 ? s1.data[key] : s2.data[key];
  }

  setSeriesValue(String key, double value) {
    setState(() {
      mode == EditionMode.data1 ? s1.data[key] = value : s2.data[key] = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildRadialSeries(),
            const Divider(color: Colors.white, height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _buildEditionModeSwitcher(),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPanButtonValue(
                  name: 'balance',
                  value: getSeriesValue('balance'),
                  color: colorMap[mode]!,
                  valueChanged: (double value) =>
                      setSeriesValue('balance', value),
                ),
                _buildPanButtonValue(
                  name: 'speed',
                  value: getSeriesValue('speed'),
                  color: colorMap[mode]!,
                  valueChanged: (double value) =>
                      setSeriesValue('speed', value),
                ),
                _buildPanButtonValue(
                  name: 'accuracy',
                  value: getSeriesValue('accuracy'),
                  color: colorMap[mode]!,
                  valueChanged: (double value) =>
                      setSeriesValue('accuracy', value),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPanButtonValue(
                  name: 'skill',
                  value: getSeriesValue('skill'),
                  color: colorMap[mode]!,
                  valueChanged: (double value) =>
                      setSeriesValue('skill', value),
                ),
                _buildPanButtonValue(
                  name: 'jump',
                  value: getSeriesValue('jump'),
                  color: colorMap[mode]!,
                  valueChanged: (double value) => setSeriesValue('jump', value),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Row _buildEditionModeSwitcher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "EDITION MODE ",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 10),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (mode == EditionMode.data1) {
                  setState(() {
                    mode = EditionMode.data2;
                  });
                } else {
                  setState(() {
                    mode = EditionMode.data1;
                  });
                }
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  color: colorMap[mode],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              mode == EditionMode.data1 ? "DATA 1" : "DATA 2",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Column _buildPanButtonValue(
      {String name = "<name>",
      double value = 0,
      Color color = Colors.white,
      required Function(double) valueChanged}) {
    return Column(
      children: [
        Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
        PanButton(
            size: 100,
            tickColor: color,
            circleStrokeColor: color,
            pointerColor: color,
            minValue: 0,
            initialValue: 0,
            sensitivity: 0.5,
            maxValue: 100,
            ticksCount: 20,
            innerOffset: 10,
            // showMeNerdsStuff:
            //     (startPanX, startPanY, curPanX, curPanY, delta) {
            //   print(
            //       "$startPanX , $startPanY, $curPanX, $curPanY, $delta");
            // },
            valueChanged: valueChanged),
        Text(
          value.toStringAsFixed(2),
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  SizedBox _buildRadialSeries() {
    return SizedBox(
      width: 250,
      height: 250,
      child: RadialSeriesWidget(
        axes: [
          RadialAxis(
            id: 'balance',
            name: 'balance',
            lineWidth: 3,
            axisColor: Colors.grey,
            legendStyle: const TextStyle(color: Colors.white),
          ),
          RadialAxis(
            id: 'speed',
            name: 'speed',
            lineWidth: 2,
            axisColor: Colors.grey,
            legendStyle: const TextStyle(color: Colors.white),
          ),
          RadialAxis(
            id: 'accuracy',
            name: 'accuracy',
            lineWidth: 2,
            axisColor: Colors.grey,
            legendStyle: const TextStyle(color: Colors.white),
            xTextOffset: -10,
            yTextOffset: -20,
          ),
          RadialAxis(
              id: 'skill',
              name: 'skill',
              lineWidth: 2,
              axisColor: Colors.grey,
              legendStyle: const TextStyle(color: Colors.white),
              yTextOffset: 10),
          RadialAxis(
            id: 'jump',
            name: 'jump',
            lineWidth: 2,
            axisColor: Colors.grey,
            legendStyle: const TextStyle(color: Colors.white),
          ),
        ],
        series: [s1, s2],
      ),
    );
  }
}
