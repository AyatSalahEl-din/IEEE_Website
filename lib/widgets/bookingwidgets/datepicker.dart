import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: WebsiteColors.primaryBlueColor,
                  onPrimary: Colors.white,
                  onSurface: WebsiteColors.darkBlueColor,
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
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width > 600 ? 12.sp : 10.sp,
          horizontal: MediaQuery.of(context).size.width > 600 ? 16.sp : 14.sp,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width > 600 ? 10.sp : 8.sp,
          ),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: WebsiteColors.primaryBlueColor,
              size: MediaQuery.of(context).size.width > 600 ? 24.sp : 20.sp,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width > 600 ? 10.sp : 8.sp,
            ),
            Text(
              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              style: TextStyle(
                fontSize:
                    MediaQuery.of(context).size.width > 600 ? 16.sp : 14.sp,
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
