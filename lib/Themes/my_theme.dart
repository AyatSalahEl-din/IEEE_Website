import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class MyTheme {
  static ThemeData theme = ThemeData(
    textTheme: TextTheme(
      displayMedium: GoogleFonts.poppins(
        color: WebsiteColors.whiteColor,
        fontWeight: FontWeight.w400,
        fontSize: 30.sp,
      ),
      displaySmall: GoogleFonts.poppins(
        color: WebsiteColors.whiteColor,
        fontWeight: FontWeight.bold,
        fontSize: 30.sp,
      ),
      displayLarge: GoogleFonts.poppins(
        color: WebsiteColors.whiteColor,
        fontWeight: FontWeight.w400,
        fontSize: 32.sp,
      ),
      headlineLarge: GoogleFonts.poppins(
        color: WebsiteColors.darkGreyColor,
        fontWeight: FontWeight.bold,
        fontSize: 54.sp,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: WebsiteColors.darkGreyColor,
        fontWeight: FontWeight.w400,
        fontSize: 54.sp,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: WebsiteColors.blackColor,
        fontWeight: FontWeight.bold,
        fontSize: 48.sp,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: WebsiteColors.darkBlueColor,
        fontWeight: FontWeight.bold,
        fontSize: 48.sp,
      ),
      titleLarge: GoogleFonts.poppins(
        color: WebsiteColors.darkGreyColor,
        fontWeight: FontWeight.bold,
        fontSize: 24.sp,
      ),
      titleMedium: GoogleFonts.poppins(
        color: WebsiteColors.darkGreyColor,
        fontWeight: FontWeight.w400,
        fontSize: 24.sp,
      ),
      titleSmall: GoogleFonts.alexandria(
        color: WebsiteColors.darkGreyColor,
        fontWeight: FontWeight.w400,
        fontSize: 56.sp,
      ),
    ),
  );
}
