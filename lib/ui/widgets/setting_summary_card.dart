import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingSummaryCard extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Container(
  //       child: Stack(
  //         fit: StackFit.loose,
  //         children: <Widget>[
  //           Positioned(
  //             top: 30,
  //             child: Text("TOP"),
  //           ),
  //           Align(
  //             alignment: Alignment.centerRight,
  //             // top: 40,
  //             child: Container(
  //               height: 250,
  //               width: 380,
  //               child: Card(
  //                 color: Colors.white,
  //                 child: Column(
  //                   children: <Widget>[
  //                     Text(""),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Positioned(
  //             bottom: 0,
  //             child: Text("BOTTOM"),
  //           ),
  //           Positioned(
  //             top: 20,
  //             left: 10,
  //             child: Container(
  //               height: 270,
  //               width: 4,
  //               color: Colors.black,
  //             ),
  //           ),
  //           Positioned(
  //             top: 22.5,
  //             left: 12,
  //             child: CustomPaint(
  //               painter: CirclePainter(),
  //             ),
  //           ),
  //           Positioned(
  //             bottom: 25,
  //             left: 12,
  //             child: CustomPaint(
  //               painter: CirclePainter(),
  //             ),
  //           ),
  //         ],
  //       ),
  //       // height: 320,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            top: 0,
            left: 0,
            bottom: 0,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TimeButton(time: "09:00 PM"),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.black,
                            width: 4,
                          ),
                        ),
                      ),
                      TimeButton(time: "${Random().nextInt(12)}:00 AM")
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 35, bottom: 35),
              child: Container(
                height: Random().nextInt(10) * 100.0,
                width: 350,
                child: Card(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TimeButton extends StatelessWidget {
  final String time;
  const TimeButton({
    Key key,
    @required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: OutlineButton(
        onPressed: () {},
        child: Text(
          time,
          style: Theme.of(context).textTheme.caption.copyWith(
                color: Colors.black,
              ),
        ),
        borderSide: BorderSide(color: Colors.black, width: 2),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = Colors.black;
    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);

    // draw the circle on centre of canvas having radius 75.0
    canvas.drawCircle(center, 6.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
