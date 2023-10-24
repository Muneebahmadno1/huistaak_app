import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../constants/global_variables.dart';
import '../helper/data_helper.dart';

class DatePickerWidget extends StatefulWidget {
  final from;

  const DatePickerWidget({super.key, required this.from});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  final DataHelper _dataController = Get.find<DataHelper>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.buttonColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: ListTile(
        horizontalTitleGap: 0,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding
        leading: Icon(
          Icons.calendar_month_outlined,
          color: AppColors.buttonColor,
        ), // Add a calendar icon in the leading position
        title: Text(
          (widget.from == 'goal'
                      ? _dataController.goalSelectedDate
                      : _dataController.selectedDate) ==
                  null
              ? 'Select Date'
              : '${DateFormat.yMMMd().format((widget.from == 'goal' ? _dataController.goalSelectedDate : _dataController.selectedDate)!)}',
          style: bodyNormal,
        ), // Format the date
        trailing: Icon(Icons.arrow_drop_down, color: Colors.black),
        onTap: () {
          _showDatePicker(context);
        },
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: (widget.from == 'goal'
              ? _dataController.goalSelectedDate
              : _dataController.selectedDate) ??
          DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.buttonColor, // Change primary color
            hintColor: AppColors.buttonColor, // Change accent color
            colorScheme: ColorScheme.light(
                primary: AppColors.buttonColor,
                background: Colors.black // Change background color
                ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null &&
        pickedDate !=
            (widget.from == 'goal'
                ? _dataController.goalSelectedDate
                : _dataController.selectedDate)) {
      setState(() {
        (widget.from == 'goal'
            ? _dataController.goalSelectedDate = pickedDate
            : _dataController.selectedDate = pickedDate);
      });
    }
  }
}
