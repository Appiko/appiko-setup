import 'package:flutter/material.dart';

class PageNavigationBar extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool showPrevious;
  final bool showNext;

  PageNavigationBar({
    Key key,
    this.onPrevious,
    this.onNext,
    @required this.showPrevious,
    @required this.showNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      //Makes the bar sticky - Even when the keyboard shows up
      offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: BottomAppBar(
        elevation: 16.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: showPrevious && showNext
                ? MainAxisAlignment.spaceBetween
                : showPrevious && !showNext
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
            children: <Widget>[
              if (showPrevious)
                FlatButton.icon(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 16,
                  ),
                  label: Text(
                    "PREVIOUS",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: onPrevious,
                ),
              if (showNext)
                FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Row(
                    children: <Widget>[
                      Text(
                        "NEXT",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8.0),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ],
                  ),
                  onPressed: onNext,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
