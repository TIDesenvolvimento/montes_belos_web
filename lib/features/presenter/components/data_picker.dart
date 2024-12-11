import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:montesBelos/features/presenter/components/data_picker_color.dart';
import 'package:montesBelos/features/presenter/components/data_picker_style.dart';
import 'package:montesBelos/features/presenter/components/data_picker_tap.dart';
import 'package:montesBelos/features/presenter/components/date_widget.dart';

class DatePickerViagem extends StatefulWidget {
  final DateTime startDate;

  final double width;

  final double height;

  final DatePickerController? controller;

  final Color selectedTextColor;

  final Color selectionColor;

  final Color deactivatedColor;

  final TextStyle monthTextStyle;

  final TextStyle dayTextStyle;

  final TextStyle dateTextStyle;

  final DateTime? initialSelectedDate;

  final List<DateTime>? inactiveDates;

  final List<DateTime>? activeDates;

  final DateChangeListener? onDateChange;

  final int daysCount;

  final String locale;

  final bool reverseDays;

  final bool animateToSelection;

  const DatePickerViagem(
    this.startDate, {
    super.key,
    this.width = 150,
    this.height = 85,
    this.controller,
    this.monthTextStyle = defaultMonthTextStyle,
    this.dayTextStyle = defaultDayTextStyle,
    this.dateTextStyle = defaultDateTextStyle,
    this.selectedTextColor = Colors.white,
    this.selectionColor = AppColors.defaultSelectionColor,
    this.deactivatedColor = AppColors.defaultDeactivatedColor,
    this.initialSelectedDate,
    this.activeDates,
    this.inactiveDates,
    this.daysCount = 500,
    this.onDateChange,
    this.reverseDays = false,
    this.animateToSelection = false,
    this.locale = "en_US",
  }) : assert(
            activeDates == null || inactiveDates == null,
            "Can't "
            "provide both activated and deactivated dates List at the same time.");

  @override
  State<StatefulWidget> createState() => _DatePickerViagemState();
}

class _DatePickerViagemState extends State<DatePickerViagem> {
  DateTime? _currentDate;

  final ScrollController _controller = ScrollController();

  late final TextStyle selectedDateStyle;
  late final TextStyle selectedMonthStyle;
  late final TextStyle selectedDayStyle;

  late final TextStyle deactivatedDateStyle;
  late final TextStyle deactivatedMonthStyle;
  late final TextStyle deactivatedDayStyle;

  @override
  void didUpdateWidget(covariant DatePickerViagem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && widget.animateToSelection) {}
  }

  @override
  void initState() {
    initializeDateFormatting(widget.locale, null);

    _currentDate = widget.initialSelectedDate;

    widget.controller?._setDatePickerState(
      this,
    );

    selectedDateStyle = widget.dateTextStyle.copyWith(
      color: widget.selectedTextColor,
    );
    selectedMonthStyle = widget.monthTextStyle.copyWith(
      color: widget.selectedTextColor,
    );
    selectedDayStyle = widget.dayTextStyle.copyWith(
      color: widget.selectedTextColor,
    );

    deactivatedDateStyle = widget.dateTextStyle.copyWith(
      color: widget.deactivatedColor,
    );
    deactivatedMonthStyle = widget.monthTextStyle.copyWith(
      color: widget.deactivatedColor,
    );
    deactivatedDayStyle = widget.dayTextStyle.copyWith(
      color: widget.deactivatedColor,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ListView.builder(
        itemCount: widget.daysCount,
        reverse: widget.reverseDays,
        scrollDirection: Axis.horizontal,
        controller: _controller,
        itemBuilder: (context, index) {
          DateTime date;
          DateTime date0 = widget.startDate.add(
            Duration(
              days: index,
            ),
          );
          date = DateTime(
            date0.year,
            date0.month,
            date0.day,
          );

          bool isDeactivated = false;

          if (widget.inactiveDates != null) {
            for (DateTime inactiveDate in widget.inactiveDates!) {
              if (DateUtils.isSameDay(date, inactiveDate)) {
                isDeactivated = true;
                break;
              }
            }
          }

          if (widget.activeDates != null) {
            isDeactivated = true;
            for (DateTime activateDate in widget.activeDates!) {
              if (DateUtils.isSameDay(date, activateDate)) {
                isDeactivated = false;
                break;
              }
            }
          }

          bool isSelected = _currentDate != null
              ? DateUtils.isSameDay(date, _currentDate)
              : false;

          return DateWidget(
            date: date,
            monthTextStyle: isDeactivated
                ? deactivatedMonthStyle
                : isSelected
                    ? selectedMonthStyle
                    : widget.monthTextStyle,
            dateTextStyle: isDeactivated
                ? deactivatedDateStyle
                : isSelected
                    ? selectedDateStyle
                    : widget.dateTextStyle,
            dayTextStyle: isDeactivated
                ? deactivatedDayStyle
                : isSelected
                    ? selectedDayStyle
                    : widget.dayTextStyle,
            width: widget.width,
            locale: widget.locale,
            selectionColor:
                isSelected ? widget.selectionColor : Colors.transparent,
            onDateSelected: (selectedDate) {
              if (isDeactivated) return;

              if (widget.onDateChange != null) {
                widget.onDateChange!(selectedDate);
              }
              setState(() {
                _currentDate = selectedDate;
              });
            },
          );
        },
      ),
    );
  }
}

class DatePickerController {
  _DatePickerViagemState? _datePickerState;

  void _setDatePickerState(_DatePickerViagemState state) {
    _datePickerState = state;
  }
}
