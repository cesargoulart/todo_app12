import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateTimeSelected;

  DatePickerWidget({required this.initialDate, required this.onDateTimeSelected});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          selectedDateTime.hour,
          selectedDateTime.minute,
        );
      });
      widget.onDateTimeSelected(selectedDateTime);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: selectedDateTime.hour, minute: selectedDateTime.minute),
    );
    if (pickedTime != null) {
      setState(() {
        selectedDateTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
      widget.onDateTimeSelected(selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text("Select Date"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text("Select Time"),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          "Selected Deadline: ${selectedDateTime.toLocal()}".split('.')[0],
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
