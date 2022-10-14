import 'package:flutter/material.dart';
import 'package:math_effects/custom-widgets/pan_button.dart';

class PanButtonDemo extends StatefulWidget {
  const PanButtonDemo({super.key});

  @override
  State<PanButtonDemo> createState() => _DemoPageState();
}

class _DemoPageState extends State<PanButtonDemo> {
  String _panStartX = "0";
  String _panStartY = "0";
  String _panCurX = "0";
  String _panCurY = "0";
  String _delta = "0";
  String _value = "0";

  void _showMeNeerdStuff(
      double psx, double psy, double pcx, double pcy, double delta) {
    setState(() {
      _panStartX = psx.toStringAsFixed(2);
      _panStartY = psy.toStringAsFixed(2);
      _panCurX = pcx.toStringAsFixed(2);
      _panCurY = pcy.toStringAsFixed(2);
      _delta = delta.toStringAsFixed(2);
    });
  }

  void _onValueChanged(double value) {
    setState(() {
      _value = value.toStringAsFixed(2);
    });
  }

  Widget _buildButton1() {
    return PanButton(
        circleStrokeColor: Colors.white,
        tickColor: Colors.white,
        pointerColor: Colors.grey.shade500,
        pointerTickSize: 10,
        pointerType: PointerType.circle,
        size: 200,
        ticksCount: 8,
        minValue: 0,
        sensitivity: 0.6,
        maxValue: 100,
        showMeNerdsStuff: _showMeNeerdStuff,
        valueChanged: _onValueChanged);
  }

  Widget _buildButton2() {
    return PanButton(
        circleStrokeColor: Colors.transparent,
        tickColor: Colors.green,
        pointerColor: Colors.black,
        circleBackgroundColor: Colors.green,
        pointerTickSize: 10,
        pointerType: PointerType.circle,
        size: 200,
        ticksCount: 30,
        minValue: 0,
        sensitivity: 0.6,
        maxValue: 100,
        showMeNerdsStuff: _showMeNeerdStuff,
        valueChanged: _onValueChanged);
  }

  Widget _buildButton3() {
    return PanButton(
        circleStrokeColor: Colors.deepPurple,
        tickColor: Colors.purple,
        pointerColor: Colors.grey.shade500,
        pointerTickSize: 10,
        pointerType: PointerType.tick,
        size: 200,
        ticksCount: 4,
        minValue: 0,
        sensitivity: 0.6,
        maxValue: 100,
        showMeNerdsStuff: _showMeNeerdStuff,
        valueChanged: _onValueChanged);
  }

  Widget _buildButton4() {
    return PanButton(
        circleStrokeColor: Colors.blue.shade200,
        tickColor: Colors.blue.shade600,
        pointerColor: Colors.grey.shade500,
        pointerTickSize: 15,
        pointerType: PointerType.tick,
        size: 200,
        ticksCount: 17,
        minValue: 0,
        sensitivity: 0.6,
        maxValue: 100,
        showMeNerdsStuff: _showMeNeerdStuff,
        valueChanged: _onValueChanged);
  }

  Widget _buildButton5() {
    return PanButton(
        circleStrokeColor: Colors.yellow,
        tickColor: Colors.red,
        pointerColor: Colors.green.shade300,
        pointerTickSize: 10,
        pointerType: PointerType.circle,
        size: 200,
        ticksCount: 8,
        minValue: 0,
        sensitivity: 0.6,
        maxValue: 100,
        showMeNerdsStuff: _showMeNeerdStuff,
        valueChanged: _onValueChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //appBar: AppBar(title: const Text("Demo page")),
      body: SafeArea(
        child: Column(children: [
          Text(
            "PanStart = ($_panStartX, $_panStartY) \nPanEnd = ($_panCurX , $_panCurY) \ndelta=$_delta \nvalue=$_value",
            style: const TextStyle(color: Colors.white),
          ),
          Row(
            children: [
              _buildButton1(),
              _buildButton2(),
            ],
          ),
          Row(
            children: [
              _buildButton3(),
              _buildButton4(),
            ],
          ),
          Row(
            children: [
              _buildButton5(),
            ],
          )
        ]),
      ),
    );
  }
}
