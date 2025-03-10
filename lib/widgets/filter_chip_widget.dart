import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;

  const FilterChipWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    double screenWidth = ScreenUtil().screenWidth; // Get screen width

    return Padding(
      padding: EdgeInsets.only(right: screenWidth < 400 ? 4.sp : 8.sp), // Adjust right padding
      child: Chip(

        label: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth < 400 ? 1 : 6.sp, // Adjust padding for better fit
            vertical: screenWidth < 400 ? .5 : 2.sp,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: WebsiteColors.blackColor,
              fontSize: screenWidth < 400 ? 20.sp : 20.sp, // Scale text size
            ),
          ),
        ),
        backgroundColor: Colors.white,
        shape: StadiumBorder(
          side: BorderSide(
            color: WebsiteColors.primaryBlueColor,
            width: screenWidth < 400 ? 1.sp : 2.sp, // Reduce border thickness
          ),
        ),
      ),
    );
  }
}
