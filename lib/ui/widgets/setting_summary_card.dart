import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingSummaryCard extends StatelessWidget {
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
                      TimeButton(
                        time: "09:00 PM",
                        onPressed: () {},
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: CustomPaint(
                                  painter: CirclePainter(),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.black,
                                  width: 3,
                                ),
                              ),
                              Container(
                                child: CustomPaint(
                                  painter: CirclePainter(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TimeButton(
                        time: "${Random().nextInt(12)}:00 AM",
                        onPressed: () {},
                      )
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
              padding: const EdgeInsets.only(top: 40, bottom: 40),
              child: Container(
                height: (Random().nextInt(6) + 2) * 70.0,
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
  final VoidCallback onPressed;
  final String time;
  const TimeButton({
    Key key,
    @required this.time,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      child: OutlineButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Text(
          time,
          style: Theme.of(context).textTheme.caption.copyWith(
                color: Colors.black,
              ),
        ),
        borderSide: BorderSide(color: Colors.black, width: 1),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.black;

    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, 5.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
