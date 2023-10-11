import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/constants/global_variables.dart';
import 'package:intl/intl.dart';

import '../controllers/general_controller.dart';

class TimePickerWidget extends StatefulWidget {
  final int index;
  final String title;
  const TimePickerWidget({super.key, required this.index, required this.title});
  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  final generalController = Get.find<GeneralController>();
  TimeOfDay? selectedTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
          Icons.access_time,
          color: Colors.black26,
        ), // Add a clock icon in the leading position
        title: Text(
          selectedTime == null
              ? widget.title
              : DateFormat.jm().format(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  selectedTime!.hour,
                  selectedTime!.minute)),
          style: headingSmall.copyWith(fontSize: 13),
        ),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: () {
          _showTimePicker(context);
        },
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      useRootNavigator: false,
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        generalController.selectedTimes[widget.index] =
            selectedTime!.format(context);
      });
    }
  }
}
