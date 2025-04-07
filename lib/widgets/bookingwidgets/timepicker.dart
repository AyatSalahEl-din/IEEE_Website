import 'package:flutter/material.dart';
import 'package:ieee_website/Themes/website_colors.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import for custom fonts

class TimePickerWidget extends StatelessWidget {
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const TimePickerWidget({
    Key? key,
    required this.selectedTime,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: const Color.fromARGB(255, 167, 217, 244),
                  onPrimary: WebsiteColors.whiteColor,
                  onSurface: WebsiteColors.darkGreyColor,
                ),
                timePickerTheme: TimePickerThemeData(
                  dialTextStyle: GoogleFonts.roboto( // Custom font for clock numbers
                    fontSize: 12, // Smaller size
                    fontWeight: FontWeight.normal, // Normal weight
                    color: WebsiteColors.darkGreyColor,
                  ),
                  dialHandColor: const Color.fromARGB(255, 167, 217, 244),
                  dialBackgroundColor: Colors.grey[200],
                  hourMinuteTextColor: WebsiteColors.darkGreyColor,
                  hourMinuteShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: WebsiteColors.darkGreyColor),
                  ),
                  dayPeriodColor: MaterialStateColor.resolveWith(
                    (states) => states.contains(MaterialState.selected)
                        ? const Color.fromARGB(255, 167, 217, 244)
                        : Colors.white,
                  ),
                  hourMinuteTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: WebsiteColors.darkGreyColor,
                  ),
                  dayPeriodTextStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: WebsiteColors.whiteColor,
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: MaterialStateColor.resolveWith(
                      (states) => states.contains(MaterialState.selected)
                          ? const Color.fromARGB(255, 167, 217, 244)
                          : Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: MaterialStateColor.resolveWith(
                          (states) => states.contains(MaterialState.selected)
                              ? WebsiteColors.primaryBlueColor
                              : Colors.grey[300]!,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [child!],
              ),
            );
          },
        );
        if (picked != null) {
          onTimeChanged(picked);
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
            Icon(Icons.access_time, color: WebsiteColors.primaryBlueColor),
            SizedBox(width: 10),
            Text(
              '${selectedTime.format(context)}',
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