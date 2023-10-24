import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/constants/global_variables.dart';
import 'package:intl/intl.dart';

import '../controllers/general_controller.dart';
import '../helper/data_helper.dart';

class TimePickerWidget extends StatefulWidget {
  final int index;
  final String title;

  const TimePickerWidget({super.key, required this.index, required this.title});

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  final generalController = Get.find<GeneralController>();
  final DataHelper _dataController = Get.find<DataHelper>();

  // TimeOfDay? selectedTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.buttonColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: ListTile(
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        // Adjust padding

        leading: Icon(
          Icons.access_time,
          color: AppColors.buttonColor,
        ),
        // Add a clock icon in the leading position
        title: Text(
          (widget.title == "Start Time"
                  ? _dataController.startTime == null
                  : _dataController.endTime == null)
              ? widget.title
              : DateFormat.jm().format(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  widget.title == "Start Time"
                      ? _dataController.startTime!.hour
                      : _dataController.endTime!.hour,
                  widget.title == "Start Time"
                      ? _dataController.startTime!.minute
                      : _dataController.endTime!.minute,
                )),
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
      initialTime: widget.title == "Start Time"
          ? _dataController.startTime ?? TimeOfDay.now()
          : _dataController.endTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null &&
        pickedTime !=
            (widget.title == "Start Time"
                ? _dataController.startTime
                : _dataController.endTime)) {
      setState(() {
        widget.title == "Start Time"
            ? _dataController.startTime = pickedTime
            : _dataController.endTime = pickedTime;
        generalController.selectedTimes[widget.index] =
            widget.title == "Start Time"
                ? _dataController.startTime!.format(context)
                : _dataController.endTime!.format(context);
      });
    }
  }
}
