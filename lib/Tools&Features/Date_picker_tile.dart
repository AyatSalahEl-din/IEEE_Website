import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final Function(DateTime?) onDatePicked;
  final DateTime? initialDate;

  const CustomDatePicker({
    super.key,
    required this.onDatePicked,
    this.initialDate,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
      title: Text(
        initialDate != null
            ? DateFormat.yMMMd().format(initialDate!)
            : "Pick a date",
        style: TextStyle(
          fontSize: 20.sp,
          color: WebsiteColors.primaryBlueColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const Icon(
        Icons.calendar_month_outlined,
        color: WebsiteColors.primaryBlueColor,
      ),
      onTap: () async {
        DateTime? newDateTime = await showRoundedDatePicker(
          customWeekDays: ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"],
          context: context,
          theme: ThemeData(
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            hintColor: WebsiteColors.darkBlueColor,
            primaryColor: WebsiteColors.primaryBlueColor,
            textTheme: TextTheme(
              bodyMedium: TextStyle(
                color: WebsiteColors.darkBlueColor,
                fontSize: 16.sp,
              ),
            ),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
            ).copyWith(background: Colors.white),
          ),
          imageHeader: const AssetImage("assets/images/IEEE.jpg"),
          lastDate: DateTime(2100),
          firstDate: DateTime(2000),
          height: 400.sp,
          borderRadius: 16.0.sp,
          styleDatePicker: MaterialRoundedDatePickerStyle(
            textStyleDayButton: TextStyle(
              fontSize: 20.sp,
              color: WebsiteColors.whiteColor,
            ),
            textStyleYearButton: TextStyle(
              fontSize: 24.sp,
              color: WebsiteColors.whiteColor,
            ),
            textStyleDayOnCalendar: TextStyle(
              fontSize: 18.sp,
              color: Colors.black,
            ),
            textStyleDayOnCalendarSelected: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textStyleDayOnCalendarDisabled: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
            sizeArrow: 24.sp,
            colorArrowNext: WebsiteColors.primaryBlueColor,
            colorArrowPrevious: WebsiteColors.primaryBlueColor,
            marginLeftArrowPrevious: 16.sp,
            marginTopArrowPrevious: 16.sp,
            marginTopArrowNext: 16.sp,
            marginRightArrowNext: 16.sp,
          ),
        );

        // If a new date is selected, update the state
        if (newDateTime != null) {
          onDatePicked(newDateTime);
        }
      },
    );
  }
}
