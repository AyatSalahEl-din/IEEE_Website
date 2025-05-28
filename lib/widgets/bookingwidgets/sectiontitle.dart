import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title, required int fontSize})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width > 600 ? 22.sp : 18.sp,
              fontWeight: FontWeight.bold,
              color: WebsiteColors.darkBlueColor,
            ),
          ),
          SizedBox(height: 5.sp),
          Container(
            width: 60.sp,
            height: 3.sp,
            color: WebsiteColors.primaryYellowColor,
          ),
        ],
      ),
    );
  }
}
