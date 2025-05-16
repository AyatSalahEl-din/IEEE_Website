import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ieee_website/Themes/website_colors.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 450.sp,
          height: 600.sp,
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            color: WebsiteColors.whiteColor,
            borderRadius: BorderRadius.circular(15.sp),
            boxShadow: [
              BoxShadow(
                color: WebsiteColors.primaryBlueColor.withOpacity(0.1),
                blurRadius: 40.sp,
                spreadRadius: 2.sp,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.sp,
                backgroundColor: iconColor,
                child: Icon(icon, color: WebsiteColors.whiteColor, size: 50.sp),
              ),

              SizedBox(height: 25.sp),
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: WebsiteColors.visionColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.sp),
              Text(
                description,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: WebsiteColors.descGreyColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}