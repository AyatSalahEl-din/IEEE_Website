import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Themes/website_colors.dart';


class CustomElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: WebsiteColors.primaryBlueColor,
        padding: EdgeInsets.symmetric(vertical: 6.sp, horizontal: 10.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.sp),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: WebsiteColors.whiteColor,
          fontSize: 30.sp,
        ),
      ),
    );
  }
}
