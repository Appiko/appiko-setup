import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:setup/ui/devices/sense_be_rx/1.0/profiles/profile_summary_view.dart';

/// {@category Widget}
/// {@category Design}
///
///
/// Bottom Action bar as used in [ProfileSummaryView]
class BottomActionBar extends StatelessWidget {
  final String actionLabel;
  final bool showProfileButton;

  final VoidCallback onActionPressed;
  final VoidCallback onClosePressed;
  final VoidCallback onProfileButtonPressed;

  final Icon actionIcon;

  const BottomActionBar({
    Key key,
    @required this.actionLabel,
    this.showProfileButton,
    this.onActionPressed,
    this.actionIcon,
    this.onClosePressed,
    this.onProfileButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2.0),
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
                          Icon(OMIcons.collectionsBookmark),
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
                  icon: actionIcon,
                  label: actionLabel.length < 4
                      ? Text(
                          "${actionLabel.toUpperCase().padLeft((4 + (actionLabel.length / 2)).floor()).padRight(8)}",
                        )
                      : Text(actionLabel.toUpperCase()),
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
