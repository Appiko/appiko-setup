import 'package:flutter/material.dart';

class AdvancedOptionTile extends StatefulWidget {
  bool value;
  final ValueChanged<bool> onChanged;

  AdvancedOptionTile({Key key, this.value, this.onChanged}) : super(key: key);

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
          onChanged: (value) {
            widget.onChanged(value);
            setState(() {
              widget.value = value;
            });
          }),
    );
  }
}
