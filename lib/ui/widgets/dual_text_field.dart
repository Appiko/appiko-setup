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

/// {@category Widget}
/// {@category Design}
///
class DualTextField extends StatefulWidget {
  final String title;
  final String description;
  final String firstFieldLabel;
  final String secondFieldLabel;
  final num firstFieldMax;
  final num firstFieldMin;
  final num secondFieldMax;
  final num secondFieldMin;
  final num firstFieldValue;
  final num secondFieldValue;
  final TextEditingController t1Controller;
  final TextEditingController t2Controller;

  const DualTextField({
    Key key,
    @required this.title,
    this.description,
    this.firstFieldLabel,
    this.secondFieldLabel,
    @required this.firstFieldMax,
    @required this.firstFieldMin,
    @required this.secondFieldMax,
    @required this.secondFieldMin,
    @required this.t1Controller,
    @required this.t2Controller,
    this.firstFieldValue,
    this.secondFieldValue,
  }) : super(key: key);

  @override
  _DualTextFieldState createState() => _DualTextFieldState();
}

// TODO: Implement validators
class _DualTextFieldState extends State<DualTextField> {
  @override
  void initState() {
    // TODO: Fix default values
    if (widget.t1Controller.text == "")
      widget.t1Controller.text =
          widget.firstFieldMin.toString().padLeft(2, "0");
    if (widget.t2Controller.text == "")
      widget.t2Controller.text =
          (widget.secondFieldMin).toString().padLeft(2, "0");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 20.0),
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
                child: TextFormField(
                  controller: widget.t1Controller,
                  decoration: InputDecoration(
                    labelText: widget.firstFieldLabel ?? "hours",
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    helperText:
                        "${widget.firstFieldMin.toString().padLeft(2, '0')}:${widget.secondFieldMin.toString().padLeft(2, '0')} - ${widget.firstFieldMax.toString().padLeft(2, '0')}:${widget.secondFieldMax.toString().padLeft(2, '0')}",
                    errorBorder:
                        Theme.of(context).inputDecorationTheme.border.copyWith(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight),
                            ),
                    focusedErrorBorder:
                        Theme.of(context).inputDecorationTheme.border.copyWith(
                              borderSide: BorderSide(width: 2),
                            ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (str) {
                    double t1Value = double.tryParse(widget.t1Controller.text);
                    double t2Value = double.tryParse(widget.t2Controller.text);
                    if (t1Value == null) {
                      return "${widget.firstFieldLabel} cannot be empty";
                    }
                    if (t2Value == null) {
                      return "${widget.secondFieldLabel} cannot be empty";
                    }
                    if (t1Value < widget.firstFieldMin ||
                        t1Value > widget.firstFieldMax) {
                      return "${widget.firstFieldLabel} not in range";
                    }
                    if (t2Value < widget.secondFieldMin ||
                        t2Value > widget.secondFieldMax) {
                      return "${widget.secondFieldLabel} not in range";
                    }
                    if (t1Value == t2Value && t1Value == 0) {
                      return "Cannot be zero";
                    }
                    return null;
                  },
                  autovalidate: true,
                ),
              ),
              SizedBox(width: 16),
              Flexible(
                child: TextFormField(
                  controller: widget.t2Controller,
                  decoration: InputDecoration(
                    labelText: widget.secondFieldLabel ?? "minutes",
                    labelStyle: null,
                    errorBorder: Theme.of(context).inputDecorationTheme.border,
                  ),
                  keyboardType: TextInputType.number,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
