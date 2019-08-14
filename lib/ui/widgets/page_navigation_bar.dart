import 'package:flutter/material.dart';

/// {@category Widget}
/// {@category Design}
///
/// Bottom action bar with `Next` and `Previous` options by default
///
/// Example
///
/// ```dart
/// PageNavigationBar(
///             showNext: true,
///             showPrevious: false,
///             onNext: () {
///               Navigator.pushNamed(context, '/sense-be/motion-setting');
///             },
///           );
/// ```
///

class PageNavigationBar extends StatelessWidget {
  /// Fuction to call when previous is clicked
  final VoidCallback onPrevious;

  /// Function to call when next is clicked
  final VoidCallback onNext;

  /// Show PREVIOUS button
  final bool showPrevious;

  /// show NEXT button
  final bool showNext;

  /// next and previous button labels
  final String nextLabel;
  final String previousLabel;

  PageNavigationBar({
    Key key,
    this.onPrevious,
    this.onNext,
    @required this.showPrevious,
    @required this.showNext,
    this.nextLabel,
    this.previousLabel,
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
                    previousLabel ?? "PREVIOUS",
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontWeight: FontWeight.bold,
                          color: (onPrevious != null)
                              ? null
                              : Theme.of(context).disabledColor,
                        ),
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
                        nextLabel ?? "NEXT",
                        style: Theme.of(context).textTheme.button.copyWith(
                              fontWeight: FontWeight.bold,
                              color: (onNext != null)
                                  ? null
                                  : Theme.of(context).disabledColor,
                            ),
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
