import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                textTheme: TextTheme(
                  bodyMedium: TextStyle(
                    fontSize: 16,
                    color: WebsiteColors.darkBlueColor,
                  ),
                  titleLarge: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: WebsiteColors.primaryBlueColor,
                  ),
                ),
                colorScheme: ColorScheme.light(
                  primary: WebsiteColors.primaryBlueColor,
                  onPrimary: Colors.white,
                  onSurface: WebsiteColors.darkBlueColor,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: WebsiteColors.primaryBlueColor,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onDatePicked(picked);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              initialDate != null
                  ? DateFormat.yMMMd().format(initialDate!)
                  : "Pick a date",
              style: TextStyle(
                fontSize: 14,
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
