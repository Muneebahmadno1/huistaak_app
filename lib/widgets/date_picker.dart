import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/global_variables.dart';

class DatePickerWidget extends StatefulWidget {
  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.black12)),
      child: ListTile(
        horizontalTitleGap: 0,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding
        leading: Icon(
          Icons.calendar_month_outlined,
          color: Colors.black26,
        ), // Add a calendar icon in the leading position
        title: Text(
          selectedDate == null
              ? 'Select Date'
              : '${DateFormat.yMMMd().format(selectedDate!)}',
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
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
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

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}
