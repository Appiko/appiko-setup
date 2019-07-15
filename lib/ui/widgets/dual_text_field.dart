import 'package:flutter/material.dart';

/// Example
///
/// ```dart
/// DualTextField(
///       title: "Hello",
///       description: "This is a description",
///       secondFieldLabel: "seconds",
///       firstFieldMax: 12,
///       firstFieldMin: 00,
///       secondFieldMax: 59,
///       secondFieldMin: 50,
///       firstFieldValue: 10,
///       secondFieldValue: 12,
///     );
/// ```

class DualTextField extends StatefulWidget {
  final String title;
  final String description;
  final String firstFieldLabel;
  final String secondFieldLabel;
  final int firstFieldMax;
  final int firstFieldMin;
  final int secondFieldMax;
  final int secondFieldMin;
  final int firstFieldValue;
  final int secondFieldValue;

  DualTextField({
    Key key,
    @required this.title,
    this.description,
    this.firstFieldLabel,
    this.secondFieldLabel,
    @required this.firstFieldMax,
    @required this.firstFieldMin,
    @required this.secondFieldMax,
    @required this.secondFieldMin,
    this.firstFieldValue,
    this.secondFieldValue,
  }) : super(key: key);

  @override
  _DualTextFieldState createState() => _DualTextFieldState();
}

// TODO: Implement validators
class _DualTextFieldState extends State<DualTextField> {
  final TextEditingController t1Controller = TextEditingController();
  final TextEditingController t2Controller = TextEditingController();

  @override
  void initState() {
    // TODO: Fix default values
    t1Controller.text =
        widget.firstFieldValue?.toString()?.padLeft(2, "0") ?? "00";
    t2Controller.text =
        widget.secondFieldValue?.toString()?.padLeft(2, "0") ?? "00";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 24.0),
          ),
          widget.description != null
              ? Text(
                  widget.description,
                  style: Theme.of(context).textTheme.body2,
                )
              : Container(),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: TextField(
                  controller: t1Controller,
                  onChanged: (s) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: widget.firstFieldLabel ?? "hours",
                    helperText:
                        "Cannot be more than ${widget.firstFieldMax}:${widget.secondFieldMax.toString().padLeft(2, '0')}",
                    helperStyle: TextStyle(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 16),
              Flexible(
                child: TextField(
                  controller: t2Controller,
                  decoration: InputDecoration(
                      labelText: widget.secondFieldLabel ?? "minutes"),
                  keyboardType: TextInputType.number,
                  onChanged: (s) {
                    setState(() {});
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
