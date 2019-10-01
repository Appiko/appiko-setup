import 'package:flutter/material.dart';
import 'package:setup/core/models/generic/camera.dart';

/// {@category Widget}
/// {@category Design}
///
/// Advanced options tile.
/// As shown in [MultiplePicturesSetting] and similar places.
class AdvancedOptionTile extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AdvancedOptionTile({
    Key key,
    @required this.value,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _AdvancedOptionTileState createState() => _AdvancedOptionTileState();
}

class _AdvancedOptionTileState extends State<AdvancedOptionTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text(
        "Advanced Options".toUpperCase(),
        style: Theme.of(context).textTheme.button.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      trailing: Switch.adaptive(
        value: widget.value,
        onChanged: widget.onChanged,
      ),
    );
  }
}
