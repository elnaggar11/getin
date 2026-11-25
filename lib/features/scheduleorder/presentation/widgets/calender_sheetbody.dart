import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/shared/widgets/edit_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../shared/widgets/button_widget.dart';

class CalenderSheetbody extends StatefulWidget {
  const CalenderSheetbody({super.key});

  @override
  State<CalenderSheetbody> createState() => _CalenderSheetbodyState();
}

class _CalenderSheetbodyState extends State<CalenderSheetbody> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final TextEditingController _timeController = TextEditingController();

  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  String _combineDateTime(DateTime date, TimeOfDay? time) {
    final DateTime combined = DateTime(
      date.year,
      date.month,
      date.day,
      time?.hour ?? 0,
      time?.minute ?? 0,
    );
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(combined);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          61.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocalizationHelper.tr.delivery_location,
                style: TextStyles.font14BlackMedium.copyWith(
                  color: LightThemeColors.black,
                  fontWeight: FontWeights.extraBold,
                ),
              ),
              SvgPicture.asset(SvgAssets.cannerIcon),
            ],
          ),
          20.ph,
          const Divider(
            thickness: 1,
            height: 0,
            color: LightThemeColors.darkwhite,
          ),
          30.ph,
          TextFormFieldWidget(
            controller: _timeController,
            readOnly: true,
            onTap: _pickTime,
            hintText: LocalizationHelper.tr.delivery_time,
            prefixWidget: Padding(
              padding: const EdgeInsetsDirectional.only(start: 16),
              child: SvgPicture.asset(SvgAssets.timer),
            ),
          ),
          30.ph,
          TableCalendar(
            locale: 'en_US',
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 30)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (selectedDay.isAfter(
                DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
              )) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = selectedDay;
                });
              }
            },
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: {
              CalendarFormat.month: LocalizationHelper.tr.month,
            },
            headerStyle: const HeaderStyle(
              leftChevronVisible: true,
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeights.medium,
                color: Colors.black,
              ),
            ),
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(8),
                color: LightThemeColors.primary,
              ),
              todayDecoration: BoxDecoration(
                color: LightThemeColors.grey,
                // borderRadius: BorderRadius.circular(8),
              ),
              defaultTextStyle: TextStyle(fontSize: 16),
              weekendTextStyle: TextStyle(fontSize: 16),
            ),
          ),
          30.ph,
          ButtonWidget(
            title: LocalizationHelper.tr.save_action,
            onTap: () {
              if (_selectedTime == null) {
                Alerts.snack(
                  text: LocalizationHelper.tr.delivery_time,
                  state: SnackState.failed,
                );
                return;
              }

              final DateTime combinedDateTime = DateTime(
                _selectedDay.year,
                _selectedDay.month,
                _selectedDay.day,
                _selectedTime!.hour,
                _selectedTime!.minute,
              );

              final minAllowedTime =
                  DateTime.now().add(const Duration(minutes: 10));
              if (combinedDateTime.isBefore(minAllowedTime)) {
                Alerts.snack(
                  text: LocalizationHelper.tr.time_must_be_at_least_10_minutes,
                  state: SnackState.failed,
                );
                return;
              }

              final result = _combineDateTime(_selectedDay, _selectedTime);
              Navigator.pop(context, result);
            },
          ),
          46.ph,
        ],
      ),
    );
  }
}
