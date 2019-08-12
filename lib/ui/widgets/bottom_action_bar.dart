import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomActionBar extends StatelessWidget {
  final String actionLabel;
  final bool showProfileButton;

  final VoidCallback onActionPressed;
  final VoidCallback onClosePressed;
  final VoidCallback onProfileButtonPressed;

  const BottomActionBar({
    Key key,
    @required this.actionLabel,
    this.showProfileButton,
    this.onActionPressed,
    this.onClosePressed,
    this.onProfileButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            showProfileButton != null
                ? Container(
                    child: FlatButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Row(
                        children: [
                          Text(
                            "Profiles",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.keyboard_arrow_up),
                        ],
                      ),
                      onPressed: onProfileButtonPressed,
                    ),
                  )
                : Container(height: 0),
            Row(
              children: <Widget>[
                FloatingActionButton.extended(
                  heroTag: null,
                  label: Text(
                    "${actionLabel.toUpperCase().padLeft((4 + (actionLabel.length / 2)).floor()).padRight(8)}",
                  ),
                  onPressed: onActionPressed,
                ),
                FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text(
                    "CLOSE",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: onClosePressed,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
