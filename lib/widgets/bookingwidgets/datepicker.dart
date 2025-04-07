import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const DatePickerWidget({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2025),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: WebsiteColors.primaryBlueColor,
                ),
                // Customize additional date picker styles here
                textTheme: TextTheme(
                  titleLarge: TextStyle(color: WebsiteColors.darkGreyColor),
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onDateChanged(picked);
        }
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: WebsiteColors.primaryBlueColor,
            ),
            SizedBox(width: 10),
            Text(
              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: WebsiteColors.darkGreyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}