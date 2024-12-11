import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:montesBelos/features/presenter/components/data_picker_tap.dart';

class DateWidget extends StatelessWidget {
  final double? width;
  final DateTime date;
  final TextStyle? monthTextStyle, dayTextStyle, dateTextStyle;
  final Color selectionColor;
  final DateSelectionCallback? onDateSelected;
  final String? locale;

  const DateWidget({
    super.key,
    required this.date,
    required this.monthTextStyle,
    required this.dayTextStyle,
    required this.dateTextStyle,
    required this.selectionColor,
    this.width,
    this.onDateSelected,
    this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: width,
        margin: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "${DateFormat("MMM", locale).format(date)[0].toUpperCase()}${DateFormat("MMM", locale).format(date).substring(1).toLowerCase()}" +
                              ' ', // Month
                          style: monthTextStyle),
                      Text(date.day.toString(), style: dateTextStyle),
                    ],
                  ),
                  Text(
                      "${DateFormat("E", locale).format(date)[0].toUpperCase()}${DateFormat("E", locale).format(date).substring(1).toLowerCase()}",
                      style: dayTextStyle)
                ],
              ),
            ),
            Container(
              height: 1,
              color: selectionColor,
            )
          ],
        ),
      ),
      onTap: () {
        if (onDateSelected != null) {
          onDateSelected!(date);
        }
      },
    );
  }
}
