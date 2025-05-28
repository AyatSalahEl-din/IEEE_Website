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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width > 600 ? 12.sp : 8.sp,
        ),
      ),
      title: Text(
        initialDate != null
            ? DateFormat.yMMMd().format(initialDate!)
            : "Pick a date",
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width > 600 ? 20.sp : 16.sp,
          color: WebsiteColors.primaryBlueColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Icon(
        Icons.calendar_month_outlined,
        color: WebsiteColors.primaryBlueColor,
        size: MediaQuery.of(context).size.width > 600 ? 24.sp : 20.sp,
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
                fontSize:
                    MediaQuery.of(context).size.width > 600 ? 16.sp : 14.sp,
              ),
            ),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
            ).copyWith(background: Colors.white),
          ),
          imageHeader: const AssetImage("assets/images/IEEE.jpg"),
          lastDate: DateTime(2100),
          firstDate: DateTime(2000),
          height: MediaQuery.of(context).size.width > 600 ? 400.sp : 300.sp,
          borderRadius: MediaQuery.of(context).size.width > 600 ? 16.sp : 12.sp,
          styleDatePicker: MaterialRoundedDatePickerStyle(
            textStyleDayButton: TextStyle(
              fontSize: MediaQuery.of(context).size.width > 600 ? 20.sp : 16.sp,
              color: WebsiteColors.whiteColor,
            ),
            textStyleYearButton: TextStyle(
              fontSize: MediaQuery.of(context).size.width > 600 ? 24.sp : 20.sp,
              color: WebsiteColors.whiteColor,
            ),
            textStyleDayOnCalendar: TextStyle(
              fontSize: MediaQuery.of(context).size.width > 600 ? 18.sp : 14.sp,
              color: Colors.black,
            ),
            textStyleDayOnCalendarSelected: TextStyle(
              fontSize: MediaQuery.of(context).size.width > 600 ? 20.sp : 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textStyleDayOnCalendarDisabled: TextStyle(
              fontSize: MediaQuery.of(context).size.width > 600 ? 16.sp : 12.sp,
              color: Colors.grey,
            ),
            sizeArrow: MediaQuery.of(context).size.width > 600 ? 24.sp : 20.sp,
            colorArrowNext: WebsiteColors.primaryBlueColor,
            colorArrowPrevious: WebsiteColors.primaryBlueColor,
            marginLeftArrowPrevious:
                MediaQuery.of(context).size.width > 600 ? 16.sp : 12.sp,
            marginTopArrowPrevious:
                MediaQuery.of(context).size.width > 600 ? 16.sp : 12.sp,
            marginTopArrowNext:
                MediaQuery.of(context).size.width > 600 ? 16.sp : 12.sp,
            marginRightArrowNext:
                MediaQuery.of(context).size.width > 600 ? 16.sp : 12.sp,
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
