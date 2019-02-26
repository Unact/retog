
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.decoration,
    this.child,
    this.valueText,
    this.onPressed }) : super(key: key);

  final String valueText;
  final VoidCallback onPressed;
  final Widget child;
  final InputDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: decoration,
        isEmpty: valueText == null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText ?? ''),
            Icon(Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70
            ),
          ],
        ),
      ),
    );
  }
}

class DatePickerWidget extends StatelessWidget {
  const DatePickerWidget({
    Key key,
    this.decoration,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);

  final InputDecoration decoration;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101)
    );
    if (picked != null && picked != selectedDate)
      selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            decoration: decoration,
            valueText: selectedDate != null ? DateFormat.yMMMd('ru').format(selectedDate) : null,
            onPressed: () { _selectDate(context); },
          ),
        )
      ],
    );
  }
}
