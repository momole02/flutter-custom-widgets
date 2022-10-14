import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:math_effects/pan_demo.dart';
import 'package:math_effects/radial_series_demo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PanButtonDemo())),
                  child: _buildDemoThumb(
                    path: "lib/assets/images/panbutton.png",
                    text: "PanButton demo",
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RadialSeriesDemo())),
                  child: _buildDemoThumb(
                    path: "lib/assets/images/radialseries.png",
                    text: "RadialSeries demo",
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Powered by : ",
                  style: TextStyle(color: Colors.white),
                ),
                Image.asset(
                  "lib/assets/images/yenoo.png",
                  width: 100,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container _buildDemoThumb({String path = "", String text = ""}) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(children: [
          Image.asset(
            path,
            //  "lib/assets/images/panbutton.png",
            width: 150,
          ),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
            //  "PanButton Demo",
          ),
        ]),
      ),
    );
  }
}
